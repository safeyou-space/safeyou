import {Component, EventEmitter, Input, OnInit, Output, ViewChild} from '@angular/core';
import {FormBuilder, FormControl, FormGroup, Validators} from "@angular/forms";
import {AngularMultiSelect} from "angular2-multiselect-dropdown";
import {HelperService} from "../../../../../shared/helper.service";
import * as customBuild from '../../../../../shared/ckCustomBuild/build/ckeditor.js';
import {ChangeEvent} from "@ckeditor/ckeditor5-angular";
import {RequestService} from "../../../../../shared/request.service";
import {environment} from "../../../../../../environments/environment.prod";
import {ActivatedRoute} from "@angular/router";


@Component({
  selector: 'app-push-notification-edit-create',
  templateUrl: './push-notification-edit-create.component.html',
  styleUrls: ['./push-notification-edit-create.component.css']
})
export class PushNotificationEditCreateComponent implements OnInit {

  public Editor = customBuild;
  @Input() config = {

    toolbar: ['heading', 'bold', 'italic', 'link', 'outdent','blockQuote','insertTable', 'indent', 'numberedList', 'bulletedList', 'imageUpload', 'undo', 'redo','mediaEmbed' ],
    image: {
      styles: [
        'alignLeft', 'alignCenter', 'alignRight'
      ],
      resizeOptions: [
        {
          name: 'resizeImage:original',
          label: 'Original',
          value: null
        },
        {
          name: 'resizeImage:50',
          label: '25%',
          value: '25'
        },
        {
          name: 'resizeImage:50',
          label: '50%',
          value: '50'
        },
        {
          name: 'resizeImage:75',
          label: '75%',
          value: '75'
        }
      ],
      toolbar: [
        'imageStyle:alignLeft', 'imageStyle:alignCenter', 'imageStyle:alignRight',
        '|',
        'ImageResize',
        '|',
        'imageTextAlternative'
      ]
    },
    mediaEmbed: {
      toolbar: [
        'imageStyle:alignLeft', 'imageStyle:alignCenter', 'imageStyle:alignRight',
        '|',
        'ImageResize',
        '|',
        'imageTextAlternative'
      ]
    },
    language: 'en',
  };
  wordCount: any;
  letterCount: any;



  @Output() closePage = new EventEmitter();
  @ViewChild('dropdownRef',{static:false}) dropdownRef:any = AngularMultiSelect;
  @ViewChild('dropdownRef2',{static:false}) dropdownRef2:any = AngularMultiSelect;
  itemList: any;
  selectedItems: any;
  settings = {};
  settings2 = {};
  itemList2: any;
  selectedItems2: any;
  // form = new FormGroup({
  //   date: new FormControl('', Validators.required),
  //   time: new FormControl('', Validators.required),
  //   title: new FormControl('', Validators.required),
  //   content: new FormControl('', Validators.required),
  //   action1: new FormControl('', Validators.required),
  //   action2: new FormControl('', Validators.required),
  // });
  language: any;
  country: any;
  url: string = '';
  form = new FormGroup({
    date: new FormControl(''),
    time: new FormControl(''),
    notification_title: new FormControl('', Validators.required),
    report: new FormControl('', Validators.required),
    notification_type: new FormControl(''),
    user_id: new FormControl('', Validators.required),
  });

  constructor(public fb: FormBuilder,
              public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public helperService: HelperService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.url}/api/${environment.admin.push_notification.get}`
  }

  ngOnInit(): void {
    this.form.get('time')?.disable();
    let selectedDate;
    this.form.get('date')?.valueChanges.subscribe((res) => {
      this.form.get('time')?.setValidators(Validators.required);
      this.form.get('date')?.setValidators(Validators.required);
      this.form.get('time')?.reset();
      this.form.get('time')?.enable();
      selectedDate = new Date(res);
    })
    this.form.get('time')?.valueChanges.subscribe((res) => {
      if (res) {
        let currentTime = new Date();
        if (`${selectedDate.getFullYear()}-${selectedDate.getMonth()}-${selectedDate.getDate()}` == `${currentTime.getFullYear()}-${currentTime.getMonth()}-${currentTime.getDate()}`) {
          if (new Date().getHours() > res.split(':', 1)[0] || (new Date().getHours() >= res.split(':', 1)[0] && new Date().getMinutes() >= res.split(':')[1])) {
            this.form.get('time')?.setErrors({time: true});
          }
        }
      }
    })
    this.itemList = [
      {"id": 1, "itemName": this.helperService.translation?.cancel},
      {"id": 2, "itemName": this.helperService.translation?.reject},
      {"id": 3, "itemName": this.helperService.translation?.read_more},
    ];

    this.selectedItems = [];

    this.itemList2 = [
      // {"id": 1, "itemName": this.helperService.translation?.cancel},
      // {"id": 2, "itemName": this.helperService.translation?.reject},
      // {"id": 3, "itemName": this.helperService.translation?.read_more},
    ];

    this.selectedItems2 = [];

    setTimeout(() => {
      this.settings = {
        text: this.helperService.translation?.select_action,
        selectAllText: 'Select All',
        unSelectAllText: 'UnSelect All',
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);

    setTimeout(() => {
      this.settings2 = {
        text: this.helperService.translation?.select_action2,
        selectAllText: 'Select All',
        unSelectAllText: 'UnSelect All',
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: false,
        autoPosition: false,
        lazyLoading: true
      };
    },0);
    this.getUserList();
  }

  onChangeEditor( { editor }: ChangeEvent ) {
    if (editor != undefined) {
      this.wordCount = this.helperService._getWords(editor.model.document.getRoot());
      this.letterCount = this.helperService._getCharacters(editor.model.document.getRoot());
    }
  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

  onSubmit() {
    if (this.form.valid) {
      let userIds = [] as any;
      for (let i = 0; i < this.form.value.user_id.length; i++) {
        userIds.push(this.form.value.user_id[i].id);
      }
      let date;
      if (this.form.value.date && this.form.value.time) {
        date = `${new Date(this.form.value.date).getFullYear()}-${new Date(this.form.value.date).getMonth() + 1}-${new Date(this.form.value.date).getDate()} ${this.form.value.time}`
      }
      let data = {
        notification_title: this.form.value.notification_title,
        report: this.form.value.report,
        notification_type: date ? 10 : 6,
        user_id: userIds,
      }
      date ? data['send_time'] = date : null;
      this.requestService.createData(`${this.url}`, data).subscribe((data) => {
        this.form.reset();
        this.form.get('time')?.disable();
      })
    } else {
      this.form.markAllAsTouched()
    }
  }

  getUserList() {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.push_notification.getUserList}`).subscribe((items:any) => {
      let arr = [] as any;
      for (let i = 0; i < items.length; i++) {
        arr.push({
          "id": items[i].id,
          "itemName": items[i].nickname ? items[i].nickname + ` (${items[i].uid})` : items[i].uid,
        })
      }
      this.itemList2 = [...arr];
    })
  }

  togglePage() {
    // this.closePage.emit('close')
  }

}
