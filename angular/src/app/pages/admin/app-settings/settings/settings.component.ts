import {Component, OnInit, ViewChild} from '@angular/core';
import {HelperService} from "../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {animate, state, style, transition, trigger} from "@angular/animations";
import {ModalDirective} from "ngx-bootstrap/modal";
import {FormBuilder, Validators} from "@angular/forms";

@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.css'],
  animations: [
    trigger('openClose', [
      // ...
      state('open', style({
        width: '462px',
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden',
      })),

      state('closedIf', style({
        opacity: 0,
        visibility: 'hidden',
        width: '0%',
        height: 0,
        padding: 0,
        // display: 'none'
      })),

      state('openIf', style({
        width: '20%'
      })),

      transition('openIf <=> closedIf', [
        animate('0.5s linear')
      ]),

      transition('hideColumn => showColumn', [
        animate('0.2s ease-out')
      ]),

      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
    trigger('showFilter', [
      // ...
      state('open', style({
        width: '398px',
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden'
      })),
      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
  ]
})
export class SettingsComponent implements OnInit {
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  isModalShown = false;
  isOpen = false;
  language: any;
  country: any;
  data: any;
  url: string = '';
  viewData: any;
  itemList: any = [];
  form = this.fb.group({
    value: ['', Validators.compose([Validators.required])],
    description: ['', Validators.compose([Validators.required, Validators.minLength(1)])],
    status: ['']
  });
  policeForm = this.fb.group({
    value: [null, Validators.compose([Validators.required, Validators.pattern(/^\+?([0-9]{8,})$/)])],
    description: [''],
    status: ['']
  });
  requestType : any;
  settings = {};
  id: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.settings.get}`
  }

  ngOnInit(): void {
    setTimeout(() => {
      this.settings = {
        text:this.helperService.translation?.select_category,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.data = [];
      for (let i in items) {
        this.data.push(...items[i]);
      }
    })
  }

  showViewPage (item) {
    this.isOpen = true;
    this.viewData = item;
  }

  close () {
    this.isOpen = false;
  }

  showModal(value): void {
    this.requestService.getData(`${this.url}/${value.key}`).subscribe((items: any) => {
      this.id = value.key;
      if (value.key == 'police_phone_number') {
        this.requestType = 'police';
        this.policeForm.patchValue({
          value: items?.setting?.value,
          description: items?.setting?.description,
          status: items?.setting?.status
        })
      } else {
        this.requestType = 'edit';
        let selectList = value.key == 'default_support_language' ? items['languages'] : items['help_messages'];
        let arr = [] as any;
        let selectedItem = [] as any;
        for (let i = 0; i < selectList.length; i++) {
          arr.push({
            id: selectList[i].id,
            itemName: value.key == 'default_support_language' ? selectList[i].title : selectList[i].message
          })
          if(selectList[i].id == items?.setting?.value) {
            selectedItem.push({
              id: selectList[i].id,
              itemName: value.key == 'default_support_language' ? selectList[i].title : selectList[i].message
            })
          }
        }
        this.itemList = [...arr];
        this.form.patchValue({
          description: items?.setting?.description,
          value: selectedItem,
          status: items?.setting?.status
        });
      }
      this.isModalShown = true;
    })
  }

  hideModal(): void {
    this.autoShownModal.hide();
  }

  onHidden(): void {
    this.isModalShown = false;
    this.policeForm.reset();
    this.form.reset();
  }

  save() {
    let value = {};
    if (this.requestType == 'edit') {
      for(let i in this.form.value) {
        if (this.form.value[i] instanceof Array) {
          value[i] = this.form.value[i][0].id;
        } else {
          value[i] = this.form.value[i];
        }
      }
    } else {
      value = this.policeForm.value;
    }
    this.requestService.createData(`${this.url}/${this.id}`, value).subscribe((item) => {
      this.hideModal();
      this.getData(this.url);
    })
  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }
}
