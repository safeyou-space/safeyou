import { animate, state, style, transition, trigger } from '@angular/animations';
import { AfterViewChecked, ChangeDetectionStrategy, ChangeDetectorRef, Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { FormControl, FormGroup, Validators } from "@angular/forms";
import { HelperService } from "../../../../shared/helper.service";
import { ReportModalComponent } from "../../../../components/utils/report-modal/report-modal.component";
import { SocketConnectionService } from 'src/app/shared/socketConnection.service';
import { RequestService } from 'src/app/shared/request.service';
import { apiUrlChat, environment } from 'src/environments/environment.prod';
import * as RecordRTC from 'recordrtc';
import { DeleteModalComponent } from 'src/app/components/utils/delete-modal/delete-modal.component';
import dateFormat from "dateformat";
import { Router } from '@angular/router';


@Component({
  selector: 'app-forum-chat',
  templateUrl: './forum-chat.component.html',
  styleUrls: ['./forum-chat.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  animations: [
    trigger('openClose', [

      state('open', style({
        // top: 0
      })),
      state('closed', style({
        opacity: 0,
        height: 0,
        visibility: 'hidden',
        overflow: 'hidden',
      })),


      transition('open <=> closed', [
        animate('0.3s ease-in-out')
      ]),

      state('openAnimation', style({
        transform: 'translateY(0)'

      })),
      state('closedAnimation', style({
        transform: 'translateY(40vh)',
      })),

      transition('openAnimation <=> closedAnimation', [
        animate('0.3s ease-in-out')
      ])
    ]),
  ],
})
export class ForumChatComponent implements OnInit, OnDestroy, AfterViewChecked {
  file: any;
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  isModalShown = false;
  filebase;
  editMessageContent;
  error;
  stream;
  startRecord;
  record;
  recording = false;
  mRepliID;
  fileUrl = apiUrlChat;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  @ViewChild('relativeOne') scroll;

  formMessage = new FormGroup({
    message_content: new FormControl('', [Validators.required, this.helperService.removeSpaces])
  });

  constructor(public helperService: HelperService,
    public socketConnect: SocketConnectionService,
    private requestService: RequestService,
    private router: Router,
    private changeDetector: ChangeDetectorRef) { }


  forumIdInCummunication(user) {
    let country = localStorage.getItem('countryCode');
    this.router.navigateByUrl(country + '/' + this.helperService.defaultLanguage + '/communication');
    let userKey = 'PRIVATE_CHAT_' + this.socketConnect.myUserId + '_' + user.user_id;
    this.socketConnect.callMethodOfSecondComponent(userKey, user);
  }

  public forEnter(e) {
    if (e.keyCode === 13 && !e.shiftKey) {
      e.preventDefault();
      this.onSubmitMessage()
    }
  }


  ngOnDestroy() {
    this.socketConnect.response = 0;
    this.socketConnect.scrollBottom = false;
    this.socketConnect.messageFromNotificationUrl2 = false;
    this.socketConnect.messageFromNotificationUrl = undefined;
    if (this.socketConnect.active != 'undefined' && this.socketConnect.active != undefined) {
      let url = environment.admin.communication + this.socketConnect.active + '/leave';
      this.socketConnect.active = undefined;
      this.socketConnect.activeLeave = false;
      this.requestService.getData(url, true).subscribe(res => {

      });
    }
  }

  ngAfterViewChecked() {
    if (this.socketConnect.forForumScroll) {
      this.scroll.nativeElement.scrollTop = this.scroll.nativeElement.scrollHeight;
      this.socketConnect.forForumScroll = false;
    }
    this.changeDetector.detectChanges();
  }

  hideShow(forum, divId) {

    if (this.socketConnect.messageFromNotificationUrl2) {
      this.getFullMessages();
    } else {
      if (!this.socketConnect.openReplies) {
        this.socketConnect.messageFromNotificationUrlPagination = false;
        this.socketConnect.openReplies = forum;
      } else {
        this.socketConnect.scrollBottom = false;

        this.socketConnect.openReplies = false;
        setTimeout(() => {
          let div = document.getElementById('divViewId' + divId);

          if (div) {
            this.scroll.nativeElement.scrollTop = div.offsetTop;
          }
          this.socketConnect.messageFromNotificationUrlPagination = true;
          this.socketConnect.scrollBottom = true;
        }, 500);

      }
    }
  }


  getFullMessages() {
    this.socketConnect.messages = [];
      this.socketConnect.openReplies = false;
      this.socketConnect.messageFromNotificationUrl2 = false;
      this.requestService.getData(environment.admin.communication + this.socketConnect.active + '/messages/list?skip=0&limit=30', true).subscribe((item) => {
        for (let i = 0; i < item['data'].length; i++) {
          this.socketConnect.messagesPush(item['data'][i]);
        }
        this.socketConnect.messageFromNotificationUrlPagination = true;
        setTimeout(() => {
          this.socketConnect.scrollBottom = true;
          this.socketConnect.forForumScroll = true;
          this.submit();
        }, 0);
      });
  }

  ngOnInit(): void {
    this.socketConnect.myUserId = localStorage.getItem('user_id');
  }

  download(file) {
    let a = document.createElement("a");
    a.href = apiUrlChat + file.file_path;
    a.setAttribute("download", file.file_name);
    a.click();
  }

  editMessage(event) {
    this.mRepliID = undefined;
    this.file = undefined;
    this.filebase = undefined;
    this.editMessageContent = event;
    this.formMessage.patchValue({ message_content: event.message_content });
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

  deleteMessage(item) {
    this.modal.modalRef.hide();
    this.socketConnect.forBackAllComment = false;
    this.requestService.createData(environment.admin.communication + this.socketConnect.active + '/messages/' + item.message_id + '/delete', undefined, true).subscribe((res) => {
      this.formMessage.reset();
      this.editMessageContent = undefined;
      this.mRepliID = undefined;
      this.file = undefined;
      this.filebase = undefined;
    })
  }

  startStop() {
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

  stopRecording() {
    this.recording = false;
    this.record.stop(this.processRecording.bind(this));
    this.stream.getTracks().forEach(function (track) {
      track.stop();
    });
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

  like(forum) {
    let like = forum.message_likes.filter(res => res.user_id == this.socketConnect.myUserId);
    let likeValue;
    if (like[0]) {
      likeValue = like[0].like_type == 1 ? 0 : 1;
    } else {
      likeValue = 1
    }

    this.socketConnect.socket.emit('signal', environment.SIGNAL_M_LIKED, {
      like_room_id: this.socketConnect.active,
      like_message_id: forum.message_id,
      like_is_liked: likeValue
    });


  }


  dateFormatForReplies(date) {
    let replyDate = new Date(date).getDate() == new Date().getDate() ? dateFormat(new Date(date), "HH:MM") : dateFormat(new Date(date), "mmm d, yyyy h:MM");
    return replyDate;
  }

  mRepli(forum) {
    this.editMessageContent = undefined;
    this.file = undefined;
    this.filebase = undefined;
    this.mRepliID = forum.message_id;
    if (forum.message_parent_id) {
      this.socketConnect.openReplies = forum.message_parent_id;
    } else {
      this.socketConnect.openReplies = forum.message_id;

    }

    this.formMessage.reset();
    document.getElementById('formInput')?.focus();
  }

  onSubmitMessage() {
    this.socketConnect.forBackAllComment = false;

    if (!this.mRepliID && this.socketConnect.messageFromNotificationUrl2 && !this.editMessageContent) {
        this.getFullMessages();
    } else {
      this.submit();
    }


  }

  submit() {
    if (this.formMessage.value.message_content || this.file != undefined) {
      let formData = new FormData();
      formData.append('message_type', this.formMessage.value.message_content && this.formMessage.value.message_content.length > 0 ? '1' : '2');

      if (this.formMessage.value.message_content && this.formMessage.value.message_content.length > 0) {
        formData.append('message_content', this.formMessage.value.message_content);
      }

      if (this.file) {
        formData.append('message_files[0]', this.file);
      }

      if (this.mRepliID) {
        formData.append('message_replies[0]', this.mRepliID);
      }

      let apiUrl = this.editMessageContent ? this.socketConnect.active + '/messages/' + this.editMessageContent.message_id + '/update' : this.socketConnect.active + '/messages/send';
      this.formMessage.reset();
      this.file = undefined;
      this.filebase = undefined;
      this.editMessageContent = undefined;
      this.mRepliID = undefined;
      this.requestService.createData(environment.admin.communication + apiUrl, formData, true).subscribe((res) => {

      });
    }
  }


  showModal(): void {
    this.isModalShown = true;
  }


  setStyle(parent) {
    parent.classList.toggle('w-100');
  }

  drowLike(likes: any[]) {
    for (let c of likes) {
      if (c.user_id == this.socketConnect.myUserId) {
        if (c.like_type == 1) {
          return 'assets/images/icons/icon-heart@2x.png';
        }
      }
    }

    return 'assets/images/icons/icon-heart.png';
  }

  likeCount(likes: any[]) {
    return likes.filter(res => res.like_type == 1).length;
  }

}
