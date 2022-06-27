import {Component, OnInit, ViewChild} from '@angular/core';
import {FormBuilder, Validators} from "@angular/forms";
import {HelperService} from "../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {DeleteModalComponent} from "../../../../components/utils/delete-modal/delete-modal.component";
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelpMessagesCreateEditComponent} from "./help-messages-create-edit/help-messages-create-edit.component";


@Component({
  selector: 'app-help-messages',
  templateUrl: './help-messages.component.html',
  styleUrls: ['./help-messages.component.css'],
  animations: [
    trigger('page', [
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
        visibility: 'hidden'
      })),

      state('showColumn', style({
        opacity: 1,
      })),
      state('hideColumn', style({
        zIndex: -5,
        opacity: 0,
        position: 'absolute'
      })),
      transition('showColumn => hideColumn', [
        animate('0.2s ease-out')
      ]),
      transition('hideColumn => showColumn', [
        animate('0.2s ease-out')
      ]),

      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
  ]
})
export class HelpMessagesComponent implements OnInit {
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  isOpen = false;
  showPage = true;
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
  requestType : any;
  settings = {};
  id: any;
  allPageData: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.helpMessages.get}`
  }

  ngOnInit(): void {
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.data = items['data'];
      this.allPageData = items;
    })
  }

  showViewPage (item) {
    this.isOpen = true;
    this.viewData = item;
  }

  close (item) {
    if (item == 'close-and-get') {
      this.getData(this.url);
    }
    this.showPage = true;
  }

  closeView() {
    this.isOpen = false;
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((item) => {
      this.allPageData.current_page = (this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      this.getData(this.urlConstructor());
    })
  }

  urlConstructor() {
    let url = `${this.url}?page=${this.allPageData?.current_page}`;
    return url;
  }

  showCreatePage(type, item?) {
    if (type == 'add') {
      HelpMessagesCreateEditComponent.instance.showForm();
    } else {
      HelpMessagesCreateEditComponent.instance.showForm(item);
    }
    this.showPage = false;
  }

  pageChanged(event) {
    this.getData(`${this.url}?page=${event.page}`);
  }

}
