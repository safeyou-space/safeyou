import {Component, OnInit, ViewChild} from '@angular/core';
import {animate, style, transition, trigger, state} from "@angular/animations";
import {HelperService} from "../../../../shared/helper.service";
import {environment} from "../../../../../environments/environment.prod";
import {RequestService} from "../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {DeleteModalComponent} from "../../../../components/utils/delete-modal/delete-modal.component";
import {UserRolesCreateComponent} from "./user-roles-create/user-roles-create.component";

@Component({
  selector: 'app-user-roles',
  templateUrl: './user-roles.component.html',
  styleUrls: ['./user-roles.component.css'],
  animations: [
    trigger('openClose', [
      // ...
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
export class UserRolesComponent implements OnInit {
  url: any;
  users: any;
  language: any;
  country: any;
  isOpen = true;
  showPage = true;
  showCreate = true;
  showFilter = true;
  isModalShown = false;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  userData: any;
  allPageData: any;
  static instance: UserRolesComponent;
  userId = localStorage.getItem('user_id');

  constructor(public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public helperService: HelperService) {
    UserRolesComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appAdmin.get}`;
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((res) => {
      this.users = res['data'];
      this.allPageData = res;
    })
  }

  createOrEdit(type, id?) {
    this.showCreate = false;
    this.isOpen = true;
    this.showFilter = true;
    if (type == 'edit') {
      UserRolesCreateComponent.instance.ngOnInit();
      UserRolesCreateComponent.instance.getDataById(id);
    } else if (type == 'add') {
      UserRolesCreateComponent.instance.ngOnInit();
    }
  }

  changeStatus(item) {
    let data = {
      status: item.status = item.status == 0 ? 1 : 0
    };
    this.requestService.updateData(`${this.url}/change_status`, data, item.id).subscribe((data) => {
      this.getData(this.urlConstructor());
    });
  }

  urlConstructor() {
    let url = `${this.url}?page=${this.allPageData?.current_page}`;
    return url;
  }

  pageChanged(event) {
    this.getData(`${this.url}?page=${event.page}`);
  }

  viewData(item) {
    this.userData = item;
    this.isOpen = false;
    this.showFilter = true;
  }

  close() {
    this.isOpen = true;
    UserRolesCreateComponent.instance.togglePage();
  }

  closeFilter() {
    this.showFilter = true
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((res) => {
      this.allPageData.current_page = (this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      this.getData(this.urlConstructor());
    })
  }
}
