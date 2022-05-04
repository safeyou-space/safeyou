import {Component, OnDestroy, OnInit} from '@angular/core';
import {HelperService} from 'src/app/shared/helper.service';
import {RequestService} from "../../../../shared/request.service";
import {Subscription} from "rxjs";
import {environment} from "../../../../../environments/environment.prod";
import {ActivatedRoute} from "@angular/router";
import {ForumComponent} from "../forum.component";
import {DomSanitizer} from "@angular/platform-browser";

@Component({
  selector: 'app-forum-view',
  templateUrl: './forum-view.component.html',
  styleUrls: ['./forum-view.component.css']
})
export class ForumViewComponent implements OnInit, OnDestroy {
  viewData: any = [];
  subscribe!: Subscription;
  languageList: any = [];
  activeLanguage: any;
  url: any;
  language: any;
  country: any;
  desc: any;

  constructor(public helperService: HelperService,
              public requestService: RequestService,
              public sanitizer: DomSanitizer,
              public activateRoute: ActivatedRoute) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.subscribe = this.requestService.dataId.subscribe((item: any) => {
      this.viewData = item;
      this.desc = this.sanitizer.bypassSecurityTrustHtml(this.viewData.description);
      if (this.viewData.translations)
        for (let i = 0; i < this.viewData.translations.length; i++) {
          this.languageList = [];
          this.languageList.push(this.viewData.translations[i].language);
          for (let i = 0; i < this.languageList.length; i++) {
            if (this.viewData.translation[0].language_id == this.languageList[i].id) {
              this.activeLanguage = this.languageList[i];
            }
          }
        }
    })
  }

  changeLanguage(code, id) {
    this.url = `${environment.baseUrl}/${this.country}/${code}/${environment.admin.forum.get}/${id}`;
    this.requestService.getData(this.url).subscribe((res) => {
      this.viewData = res[0];
      this.desc = this.sanitizer.bypassSecurityTrustHtml(this.viewData.description);
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


  chatOpen(id, type) {
    ForumComponent.instance.viewData(id, type)
  }

  close(){
    this.languageList = undefined;
    this.activeLanguage = undefined;
    this.viewData = undefined;
  }

  ngOnDestroy() {
    this.languageList = undefined;
    this.activeLanguage = undefined;
    this.viewData = undefined;
    this.subscribe.unsubscribe();
  }

}
