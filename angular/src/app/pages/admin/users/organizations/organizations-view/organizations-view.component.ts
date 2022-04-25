import {Component, EventEmitter, OnDestroy, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";
import {Subscription} from "rxjs";
import {RequestService} from "../../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {environment} from "../../../../../../environments/environment.prod";
import {OrganizationsComponent} from "../organizations.component";

@Component({
  selector: 'app-organizations-view',
  templateUrl: './organizations-view.component.html',
  styleUrls: ['./organizations-view.component.css']
})
export class OrganizationsViewComponent implements OnInit, OnDestroy {
  @Output() myEvent = new EventEmitter();
  viewData: any = [];
  subscribe!: Subscription;
  languageList: any = [];
  activeLanguage: any;
  url: any;
  language: any;
  country: any;

  constructor(public helperService: HelperService,
              public requestService: RequestService,
              public activateRoute: ActivatedRoute) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.subscribe = this.requestService.dataId.subscribe((item: any) => {
      this.viewData = item;
      for (let i = 0; i < this.viewData.translations.length; i++) {
        this.languageList = [];
        this.languageList.push(this.viewData.translations[i].language);
        for (let i = 0; i < this.languageList.length; i++) {
          if (this.viewData.translation[0] && (this.viewData.translation[0].language_id == this.languageList[i].id)) {
            this.activeLanguage = this.languageList[i];
          }
        }
      }
    })
  }

  changeLanguage(code, id) {
    this.url = `${environment.baseUrl}/${this.country}/${code}/${environment.admin.organization.get}/${id}`;
    this.requestService.getData(this.url).subscribe((res) => {
      this.viewData = res;
      for (let i = 0; i < this.viewData.translations.length; i++) {
        this.languageList = [];
        this.languageList.push(this.viewData.translations[i].language);
        for (let i = 0; i < this.languageList.length; i++) {
          if (code == this.languageList[i].code) {
            this.activeLanguage = this.languageList[i];
          }
        }
      }
    })
  }

  callEdit(id) {
      OrganizationsComponent.instance.getById(id)
  }

  close(){
    this.languageList = undefined;
    this.activeLanguage = undefined;
    this.viewData = undefined;
    this.myEvent.emit('close')
  }

  ngOnDestroy() {
    this.languageList = undefined;
    this.activeLanguage = undefined;
    this.viewData = undefined;
    this.subscribe.unsubscribe();
  }

}
