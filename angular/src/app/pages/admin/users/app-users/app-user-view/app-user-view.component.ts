import {Component, Input, OnInit, ViewChild} from '@angular/core';
import {RequestService} from "../../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {environment} from "../../../../../../environments/environment.prod";
import {HelperService} from "../../../../../shared/helper.service";
import {AppUsersComponent} from "../app-users.component";
import {ModalDirective} from "ngx-bootstrap/modal";

@Component({
  selector: 'app-app-user-view',
  templateUrl: './app-user-view.component.html',
  styleUrls: ['./app-user-view.component.css'],
})
export class AppUserViewComponent implements OnInit {
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  isModalShown = false;
  url: any;
  language: any;
  country: any;
  @Input() data;
  record: any;
  static instance: AppUserViewComponent;

  constructor(public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public helperService: HelperService) {
    AppUserViewComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.get}`;
  }

  callEdit(id) {
    AppUsersComponent.instance.callSubmit('Edit', id)
  }
  showModal(item): void {
    this.isModalShown = true;
    this.record = item;
  }

  hideModal(): void {
    this.autoShownModal.hide();
    setTimeout(() => {
      this.isModalShown = false;
    }, 0)
  }

  onHidden(): void {
    this.isModalShown = false;
  }
}
