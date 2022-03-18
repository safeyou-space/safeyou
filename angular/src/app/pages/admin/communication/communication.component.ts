import { AfterViewChecked, ChangeDetectionStrategy, ChangeDetectorRef, Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { FormControl, FormGroup, Validators } from "@angular/forms";
import { ModalDirective } from "ngx-bootstrap/modal";
import { animate, state, style, transition, trigger } from "@angular/animations";
import { AngularMultiSelect } from "angular2-multiselect-dropdown";
import { RequestService } from "../../../shared/request.service";
import { apiUrlChat, environment } from "../../../../environments/environment.prod";
import * as RecordRTC from 'recordrtc';
import { SocketConnectionService } from "../../../shared/socketConnection.service";
import { HelperService } from 'src/app/shared/helper.service';
import { DeleteModalComponent } from 'src/app/components/utils/delete-modal/delete-modal.component';
import { ReportModalComponent } from "../../../components/utils/report-modal/report-modal.component";

@Component({
  selector: 'app-communication',
  templateUrl: './communication.component.html',
  styleUrls: ['./communication.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  animations: [
    trigger('page', [
      // ...
      state('open', style({
        opacity: '1',
        visibility: 'visible',
        position: 'absolute',
        zIndex: 10,
        width: '100%'
      })),
      state('closed', style({
        opacity: '0',
        visibility: 'hidden',
        position: 'absolute',
        zIndex: 5,
        width: '100%'
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
  ]
})
export class CommunicationComponent implements OnInit, OnDestroy, AfterViewChecked {
  file: any;
  imgUrl = apiUrlChat;
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  isModalShown = false;
  form = new FormGroup({
    message: new FormControl('', Validators.required),
    file: new FormControl(''),
  });
  @ViewChild('dropdownRef', { static: false }) dropdownRef: any = AngularMultiSelect;
  @ViewChild('dropdownRef2', { static: false }) dropdownRef2: any = AngularMultiSelect;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  itemList: any;
  selectedItems: any;
  settings = {};
  itemListReport: any;
  selectedItemsReport: any;
  settingsReport = {};
  formSearchUser = new FormGroup({
    search: new FormControl('', Validators.required),
  });
  formMessage = new FormGroup({
    message_content: new FormControl('', [Validators.required, this.helperService.removeSpaces])
  });

  formReport = new FormGroup({
    rep_cat: new FormControl('', Validators.required),
    message: new FormControl('', Validators.required),
  });

  record;
  recording = false;
  url;
  error;
  stream;
  startRecord;
  sub: any;
  time;
  editMessageContent: any;
  filebase: any;

  constructor(public requestService: RequestService,
    public helperService: HelperService,
    private changeDetector: ChangeDetectorRef,
    public socketConnect: SocketConnectionService) {
  }

  ngOnDestroy() {
    this.socketConnect.response = 0;
    this.socketConnect.scrollBottom = false;
    this.startRecord = undefined;
    this.stopRecording(true);
    if (this.socketConnect.active != 'undefined' && this.socketConnect.active != undefined) {
      let url = environment.admin.communication + this.socketConnect.active + '/leave';
      this.socketConnect.activeLeave = false;
      this.socketConnect.active = undefined;
      this.requestService.getData(url, true).subscribe(res => {

      });
    }
  }

  ngAfterViewChecked() {
    this.changeDetector.detectChanges();
  }

  deleteMessage(item) {
    this.modal.modalRef.hide();
    this.editMessageContent = undefined;
    this.file = undefined;
    this.filebase = undefined;
    this.formMessage.reset();
    this.startRecord = undefined;
    this.stopRecording(true);
    this.requestService.createData(environment.admin.communication + this.socketConnect.active + '/messages/' + item.message_id + '/delete', undefined, true).subscribe((res) => {


    })
  }


  editMessage(event) {
    this.file = undefined;
    this.filebase = undefined;
    this.startRecord = undefined;
    this.stopRecording(true);
    this.editMessageContent = event;
    this.formMessage.patchValue({ message_content: event.message_content });
  }

  searchEvent(event) {
    this.socketConnect.userLists.findIndex((res, i) => {
      let name = res.room_name.toLowerCase();
      if (name.includes(event.target.value.toLowerCase()) != false) {
        this.socketConnect.userLists[i] = this.socketConnect.userLists[0];
        this.socketConnect.userLists[0] = res
      }
    });
  }

  onChange(event) {
    clearTimeout(this.time);
    this.socketConnect.socket.emit('signal', environment.SIGNAL_M_TYPING, {
      typing: true
    });
    this.time = setTimeout(() => {
      this.socketConnect.socket.emit('signal', environment.SIGNAL_M_TYPING, {
        typing: false
      });
    }, 2000);
  }

  ngOnInit(): void {
    this.socketConnect.myUserId = localStorage.getItem('user_id');
    this.socketConnect.invokeEvent.next(true);

    this.selectedItems = [];
    this.settings = {
      text: this.helperService?.translation?.enter_name,
      selectAllText: 'Select All',
      unSelectAllText: 'UnSelect All',
      enableSearchFilter: true,
      classes: "myclass custom-class",
      showCheckbox: true,
      singleSelection: true,
      autoPosition: false,
    };


    this.itemListReport = [
      { "id": 1, "itemName": "Հայոյանք" },
      { "id": 2, "itemName": "Վիրավորանք" },
    ];

    this.selectedItemsReport = [];
    this.settingsReport = {
      text: "Ընտրեք կատեգորյան",
      selectAllText: 'Select All',
      unSelectAllText: 'UnSelect All',
      enableSearchFilter: true,
      classes: "myclass custom-class",
      showCheckbox: true,
      singleSelection: true,
      autoPosition: false,
    };
  }

  onSubmitMessage() {
    if (this.formMessage.value.message_content || this.file != undefined) {
      let formData = new FormData();
      formData.append('message_type', this.formMessage.value.message_content && this.formMessage.value.message_content.length > 0 ? '1' : '2');

      if (this.formMessage.value.message_content && this.formMessage.value.message_content.length > 0) {
        formData.append('message_content', this.formMessage.value.message_content);
      }

      if (this.file) {
        formData.append('message_files[0]', this.file);
      }

      let apiUrl = this.editMessageContent ? this.socketConnect.active + '/messages/' + this.editMessageContent.message_id + '/update' : this.socketConnect.active + '/messages/send';

      this.formMessage.reset();
        this.file = undefined;
        this.filebase = undefined;
        this.editMessageContent = undefined;
      this.requestService.createData(environment.admin.communication + apiUrl, formData, true).subscribe((res) => {

      });
    }
  }

  showImage(src, id, name) {
    let modal = document.getElementById('myModalImage');
    let modalImg = document.getElementById('img01');
    let captionText = document.getElementById('caption');
    if (modal) {
      modal.style.display = 'block';
    }
    if (modalImg) {
      modalImg['src'] = this.requestService.imgPrefix + src;
    }
    if (captionText) {
      captionText.innerHTML = name;
    }
  }

  closeImage() {
    let modal = document.getElementById('myModalImage');
    if (modal) {
      modal.style.display = 'none';
    }
  }

  public forEnter(e) {
    if (e.keyCode === 13 && !e.shiftKey) {
      e.preventDefault();
      this.onSubmitMessage()
    }
  }

  onSubmitSearchUser() {
  }

  download(file) {
    let a = document.createElement("a");
    a.href = apiUrlChat + file.file_path;
    a.setAttribute("download", file.file_name);
    a.click();
  }

  onItemSelect(item: any) {
    if (item.user_joint_rooms) {
      this.socketConnect.leaveAndJoinRoom(item.user_joint_rooms);
      this.formSearchUser.reset();
    } else {
      let fData = new FormData();
      fData.append('room_name', item.itemName);
      fData.append('room_image', item.image);
      fData.append('room_member[0]', item.id);
      fData.append('room_type', '2');

      this.requestService.createData(environment.admin.communication + 'create', fData, true).subscribe((res) => {
        this.socketConnect.showPage = true;
        this.formSearchUser.reset();
        this.socketConnect.leaveAndJoinRoom(res['data'].room_key);
      })
    }
    this.dropdownRef.closeDropdown()

  }

  stopPlay(e) {
    document.addEventListener('play', function (e) {
      let allAudios = document.getElementsByTagName('audio');
      for (var i = 0; i < allAudios.length; i++) {
        if (allAudios[i] != e.target) {
          allAudios[i].pause();
        }
      }
    }, true);
  }

  OnItemDeSelect(item: any) {
    this.dropdownRef.closeDropdown()
  }

  uploadFile(event) {
    this.file = event.target.files[0];
    event.target.value = "";
    if (this.file.type.split('/')[0] == 'image') {
      new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(this.file);
        reader.onload = () => resolve(reader.result);
        reader.onerror = error => reject(error);
      }).then(res => { this.filebase = res; });
    } else {
      this.filebase = '../../../../../../assets/images/icons/btn-upload.png';
    }

  }


  showModal(): void {
    this.isModalShown = true;
  }

  hideModal(): void {
    this.autoShownModal.hide();
  }

  onHidden(): void {
    this.isModalShown = false;
    this.formReport.reset();
  }


  startStop() {
    this.file = undefined;
    this.filebase = undefined;
    if (this.startRecord) {
      this.initiateRecording();
    } else {
      this.stopRecording();
    }
  }


  initiateRecording() {
    this.recording = true;
    let mediaConstraints = {
      video: false,
      audio: true
    };
    navigator.mediaDevices.getUserMedia(mediaConstraints).then(this.successCallback.bind(this), this.errorCallback.bind(this));
  }

  successCallback(stream) {
    this.error = undefined;
    this.stream = stream;
    let options = {
      mimeType: "audio/mp3",
      numberOfAudioChannels: 1,
      sampleRate: 44100,
    };
    let StereoAudioRecorder = RecordRTC.StereoAudioRecorder;
    this.record = new StereoAudioRecorder(stream, options);
    this.record.record();
  }

  stopRecording(type?) {
    let val;
    if (type) {
      val = null;
    } else {
      val = this.processRecording.bind(this);
    }
    if (this.recording) {

      this.record.stop(val);
      this.stream.getTracks().forEach(function (track) {
        track.stop();
      });
    }
    this.recording = false;
  }

  processRecording(blob) {
    this.file = <File>blob;
    if (this.file != null) {
      let formData = new FormData();
      formData.append('message_type', this.formMessage.value.message_content && this.formMessage.value.message_content.length > 0 ? '1' : '2');
      if (this.formMessage.value.message_content && this.formMessage.value.message_content.length > 0) {
        formData.append('message_content', this.formMessage.value.message_content);
      }
      formData.append('message_files[0]', this.file);

      this.requestService.createData(environment.admin.communication + this.socketConnect.active + '/messages/send', formData, true).subscribe((res) => {
        this.formMessage.reset();
        this.file = undefined;
      });
    }
  }

  errorCallback(error) {
    this.error = 'Can not play audio in your browser';
    alert(this.error);
    this.startRecord = false;
  }

}
