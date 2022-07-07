import {Component, OnInit, ViewChild} from '@angular/core';
import {ModalDirective} from "ngx-bootstrap/modal";
import {DeleteModalComponent} from "../../../../components/utils/delete-modal/delete-modal.component";
import {FormBuilder} from "@angular/forms";
import {HelperService} from "../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {TranslationsEditCreateComponent} from "./translations-edit-create/translations-edit-create.component";
import {animate, state, style, transition, trigger} from "@angular/animations";

@Component({
  selector: 'app-translations',
  templateUrl: './translations.component.html',
  styleUrls: ['./translations.component.css'],
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
      state('showColumn', style({
        opacity: 1,
      })),
      state('hideColumn', style({
        zIndex: -5,
        opacity: 0,
        position: 'absolute',
      })),
      transition('showColumn => hideColumn', [
        animate('0.2s ease-out')
      ]),
      transition('hideColumn => showColumn', [
        animate('0.2s ease-out')
      ]),
      state('open', style({
        width: '558px',
        opacity: '1',
        visibility: 'visible',
      })),
      state('closed', style({
        width: 0,
        opacity: '0',
        visibility: 'hidden',
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
  ]
})
export class TranslationsComponent implements OnInit {
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  isModalShown = false;
  isOpen = true;
  showPage = true;
  language: any;
  country: any;
  data: any = [];
  url: string = '';
  viewData: any;
  itemList: any = [];
  requestType : any;
  settings = {};
  id: any;
  allPageData: any;
  itemData: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.translations.get}`
  }

  ngOnInit(): void {
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((res: any) => {
      this.data = [];
      for (let i in res) {
        let tt = {};
        for (let itm of res[i]) tt[itm['language'].code]=itm;
        this.data.push({
          key: i,
          translations: tt,

        })
      }
    })
  }

  showViewPage (item) {
    this.isOpen = false;
    this.itemData = item;
  }

  close (item?) {
    if (item == 'close-and-get') {
      this.getData(this.url);
    }
    this.showPage = true;
    this.isOpen = true;
  }

  showModal(value): void {
    this.isModalShown = true;
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((item) => {
      this.getData(this.url);
    })
  }

  urlConstructor() {
    let url = `${this.url}?page=${this.allPageData?.current_page}`;
    return url;
  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

  showCreatePage(type, item?) {
    if (type == 'add') {
      TranslationsEditCreateComponent.instance.showForm();
    } else {
      TranslationsEditCreateComponent.instance.showForm(item);
    }
    this.showPage = false;
  }

  pageChanged(event) {
    this.getData(`${this.url}?page=${event.page}`);
  }
}
