import {Component, Inject, OnDestroy, OnInit,  ViewChild} from '@angular/core';
import { animate, state, style, transition, trigger } from "@angular/animations";
import { HelperService } from 'src/app/shared/helper.service';
import {DOCUMENT} from "@angular/common";
import {environment} from "../../../../environments/environment.prod";
import {RequestService} from "../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {DeleteModalComponent} from "../../../components/utils/delete-modal/delete-modal.component";
import {ForumEditCreateComponent} from "./forum-edit-create/forum-edit-create.component";
import {ReportModalComponent} from "../../../components/utils/report-modal/report-modal.component";
import { SocketConnectionService } from 'src/app/shared/socketConnection.service';
import {BehaviorSubject, Subscription} from "rxjs";

@Component({
  selector: 'app-forum',
  templateUrl: './forum.component.html',
  styleUrls: ['./forum.component.css'],
  animations: [
    trigger('openClose', [
      state('open', style({
        width: 590,
        opacity: 1

      })),
      state('closed', style({
        opacity: 0

      })),

      state('openButton', style({
      })),
      state('closedButton', style({
        opacity: 0,
        visibility: 'hidden'
      })),

      transition('openButton <=> closedButton', [
        animate('0.5s linear')
      ]),

      state('openAnimations', style({
      })),
      state('closedAnimations', style({
        opacity: 0,
        margin: 0,
        padding: 0,
        visibility: 'hidden'
      })),

      transition('openAnimations <=> closedAnimations', [
        animate('0.5s ease-out')
      ]),

      state('closedIf', style({
        opacity: 0,
        visibility: 'hidden',
        width: '0%',
        height: 0,
        padding: 0,
      })),

      state('openIf', style({
        width: '12.5%'
      })),

      transition('openIf <=> closedIf', [
        animate('0.5s linear')
      ]),

      state('chatClose', style({
        visibility: 'hidden',
        opacity: 0
      })),

      state('chatOpen', style({
        opacity: 1
      })),

      transition('chatOpen <=> chatClose', [
        animate('0.5s ease-in')
      ]),

      transition('open <=> closed', [
        animate('0.5s linear')
      ]),
    ]),
    trigger('showFilter', [
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
  ],
})
export class ForumComponent implements OnInit, OnDestroy {
  url: any;
  forums: any;
  my_forums: any;
  allPageData: any;
  allPageDataMyForum: any;
  language: any;
  country: any;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  isModalShown = false;
  bool = false;
  categoryList = false;
  chatOpen = false;
  openAddOrCreate = false;
  elem: any;
  data: any;
  static instance: ForumComponent;
  pageType:any;
  viewItem:any;
  showFilter = false;
  activeLanguage: any;
  sortingValue: any = {'created_at': 'DESC'};
  dateRangeFilter: string = '';
  forumsType: any = 1;
  subscribe!: Subscription;
  access: any = ['list', 'view', 'edit', 'create', 'delete'];
  filterUrl: any = '';

  constructor(public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public helperService: HelperService,
              public socketConnect: SocketConnectionService,
              @Inject(DOCUMENT) private document: any) {
    ForumComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    if (localStorage.getItem('access')) {
      this.access = JSON.parse(localStorage.getItem( 'access')!)['forum'] ? JSON.parse(localStorage.getItem('access')!)['forum'] : []
    }
    let sorting =  Object.keys(this.sortingValue).length == 0 ? '' : `?sorts=${JSON.stringify(this.sortingValue)}`;
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.forum.get}`;
    this.getData(`${this.url}${encodeURI(sorting)}`);
    this.elem = document.documentElement;

    this.helperService.invokeEvent.subscribe(value => {
      if (value == true)
        this.chatOpen = true;
        document.getElementsByClassName('middleview')[0].children[0]['style']['height'] = 'calc(100vh - 115px';
        document.getElementsByClassName('middleview')[0].children[0]['style']['padding'] = 0;
    });

    this.helperService.forumGet.subscribe((item) => {
      if (item)
         this.viewData(item)
    });

    this.socketConnect.navigateForum.subscribe( res => {
      if (res) {
        this.chatOpen = false;
        let forumId = res.notify_body ?  res.notify_body.message_forum_id || res.notify_body.forum_id || res.notify_body.id : res.body.message_forum_id || res.body.forum_id  || res.body.id;
        let url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.forum.get}/${forumId}`;
        this.requestService.getData(url).subscribe(response => {
          if (res.notify_type == 1 || res.type == 1) {
            this.viewData(response);
          } else {
            this.viewData(response, 'comment', res)
          }
        }, err => {

          if (err.trim() == 'Not Found') {
              this.helperService.show404.next(false);
          }
        })
      }
    })

  }

  ngOnDestroy(): void {
      this.socketConnect.forBackAllComment = false;
      this.socketConnect.messageFromNotificationUrl2 = false;
      this.socketConnect.navigateForum = new BehaviorSubject(false);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((res) => {
      this.socketConnect.forums = res['data'] ? res['data'] : res;
      this.allPageData = res;
      if (this.socketConnect.forums instanceof Array) {
        for (let i of this.socketConnect.forums) {
          this.socketConnect.socket.emit('signal', environment.SIGNAL_NOTIFICATIONMAIN, {
            forum_id: i.id
          });
        }
      }


    })
  }

  getMyForums(url) {
    this.requestService.getData(url).subscribe((res) => {
      this.my_forums = res['data'] ? res['data'] : res;
      this.allPageDataMyForum = res;
    })
  }

  changeTab (type) {
    this.forumsType = type;
    this.sortingValue = {'created_at': 'DESC'};
    if (type == 2) {
      this.allPageDataMyForum ? this.allPageDataMyForum.current_page = 1 : undefined;
      this.getMyForums(this.urlConstructor());
    } else {
      this.allPageDataMyForum = undefined;
      this.allPageData.current_page = 1;
      this.getData(this.urlConstructor('all'));
    }
  }


  viewData(item, type?, res?) {
    this.viewItem = item;
    this.bool = true;
    this.categoryList = false;
    this.showFilter = false;
    this.requestService.getViewId(item);
    if (this.viewItem.translations) {
      for (let i = 0; i < this.viewItem.translations.length; i++) {
        let languageList: any = [];
        languageList.push(this.viewItem.translations[i].language);
        for (let i = 0; i < languageList.length; i++) {
          if (this.viewItem.translation[0].language_id == languageList[i].id) {
            this.activeLanguage = languageList[i];
          }
        }
      }
    }


    if (type == 'comment') {
        this.bool = true;
        this.helperService.callMethodOfSecondComponent(this.bool);

        if (res) {
          this.socketConnect.forBackAllComment = true;
          let messageId;
          if (res.notify_body) {
              messageId = res.notify_body.message_parent_id ? res.notify_body.message_parent_id : res.notify_body.message_id || res.notify_body.comment_id;
          } else {
              messageId = res.body.message_parent_id ? res.body.message_parent_id : res.body.message_id || res.body.comment_id;
          }
          let roomKey;

          if (res.notify_body) {
            roomKey = res.notify_body.message_room_key || res.notify_body.room_key;
          } else {
            roomKey = res.body.message_room_key || res.body.room_key;
          }

          this.socketConnect.messageFromNotificationUrl = environment.admin.communication + roomKey + '/messages/' + messageId + '/list';
        }
        this.socketConnect.callForumChat(item.id);
    }

  }

  changeLanguage(code, id) {
    let url = `${environment.baseUrl}/${this.country}/${code}/${environment.admin.forum.get}/${id}`;
    this.requestService.getData(url).subscribe((res) => {
      this.viewItem = res;
      this.requestService.getViewId(this.viewItem);
      for (let i = 0; i < this.viewItem.translations.length; i++) {
        let languageList: any = [];
        languageList.push(this.viewItem.translations[i].language);
        for (let i = 0; i < languageList.length; i++) {
          if (code == languageList[i].code) {
            this.activeLanguage = languageList[i];
          }
        }
      }
    })
  }

  pageChanged(event, type) {
    if (type == 'all') {
      this.allPageData.current_page = event.page;
      this.getData(this.urlConstructor('all'))
    } else {
      this.allPageDataMyForum.current_page = event.page
      this.getMyForums(this.urlConstructor())
    }

  }

  callSubmit(type, id?) {
    if (type == 'create') {
      ForumEditCreateComponent.instance.onSubmit('1');
    } else if (type == 'close') {
      this.bool = false;
      ForumEditCreateComponent.instance.close();
    } else if (type == 'save') {
      ForumEditCreateComponent.instance.onSubmit('0');
    } else if(type == 'edit'){
      this.chatOpen = false;
      this.bool = false;
      this.categoryList = false;
      this.showFilter = false;
      this.pageType = 'edit';
      ForumEditCreateComponent.instance.formGet();
      ForumEditCreateComponent.instance.getCategoryList();
      ForumEditCreateComponent.instance.getDataById(id, 'edit');
    } else if (type == 'create_post') {
      this.chatOpen = false;
      this.bool = false;
      this.categoryList = false;
      this.showFilter = false;
      this.pageType = 'create';
      ForumEditCreateComponent.instance.formGet();
      ForumEditCreateComponent.instance.getCategoryList();
      ForumEditCreateComponent.instance.getLanguageList();
    } else if (type == 'copy'){
      this.chatOpen = false;
      this.bool = false;
      this.categoryList = false;
      this.showFilter = false;
      this.pageType = 'copy';
      ForumEditCreateComponent.instance.formGet();
      ForumEditCreateComponent.instance.getDataById(id, 'copy');
    }
  }

  urlConstructor(type?) {
    let sorting =  Object.keys(this.sortingValue).length == 0 ? '' : `&sorts=${JSON.stringify(this.sortingValue)}`;
    let url = type == 'all' ? `${this.url}?page=${this.allPageData?.current_page ? this.allPageData?.current_page : 1}${encodeURI(sorting)}${this.dateRangeFilter}${encodeURI(this.filterUrl)}`
      : `${this.url}?forums=my&page=${this.allPageDataMyForum?.current_page ? this.allPageDataMyForum?.current_page : 1}${encodeURI(sorting)}${this.dateRangeFilter}${encodeURI(this.filterUrl)}`;
    return url;
  }

  changeStatus(id, status, type) {
    let value = {status: status == 1 ? 0 : 1};
    this.requestService.updateData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.forum.get}/change_status`, value, id).subscribe((item) => {
      this.forumsType == 1 ? this.getData(this.urlConstructor('all')) : this.getMyForums(this.urlConstructor());
    })
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((res) => {
      this.allPageData.current_page = (this.forumsType == 1 && this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      if (this.allPageDataMyForum) {
        this.allPageDataMyForum.current_page = (this.forumsType == 2 && this.allPageDataMyForum.current_page > 1 && this.allPageDataMyForum.data.length == 1) ?  this.allPageDataMyForum.current_page - 1 : this.allPageDataMyForum.current_page;
      }
      this.forumsType == 1 ? this.getData(this.urlConstructor('all')) : this.getMyForums(this.urlConstructor());
    })
  }


  close(type?) {
    this.socketConnect.forBackAllComment = false;
    this.socketConnect.messageFromNotificationUrl2 = false;
    if (type == 'chat') {
      this.chatOpen = false;
      this.requestService.getViewId(this.viewItem);
    } else if (type == 'openAddOrCreate') {
      this.openAddOrCreate = false;
      this.chatOpen = false;
      this.bool = false;
    }
    else {
      this.categoryList = false;
      this.bool = false;
    }
  }

  openFullScreen() {
    if (this.elem.requestFullscreen) {
      this.elem.requestFullscreen();
    } else if (this.elem.mozRequestFullScreen) {
      this.elem.mozRequestFullScreen();
    } else if (this.elem.webkitRequestFullscreen) {
      this.elem.webkitRequestFullscreen();
    } else if (this.elem.msRequestFullscreen) {
      this.elem.msRequestFullscreen();
    }

    if (this.document.mozCancelFullScreen) {
      this.document.mozCancelFullScreen();
    } else if (this.document.webkitExitFullscreen) {
      this.document.webkitExitFullscreen();
    } else if (this.document.msExitFullscreen) {
      this.document.msExitFullscreen();
    }
  }

  saveDateRange(data) {
    this.dateRangeFilter = data ? data[2] : '';
    this.allPageData.current_page = 1;
    this.forumsType == 1 ? this.getData(this.urlConstructor('all')) : this.getMyForums(this.urlConstructor());
  }

  closeFilter() {
    this.showFilter = false;
  }

  sorting(value, type?) {
    if (this.sortingValue[value]) {
      this.sortingValue[value] = this.sortingValue[value] == 'ASC' ? 'DESC' : !delete this.sortingValue[value];
    } else {
      this.sortingValue = {};
      this.sortingValue[value] = type;
    }
    if(this.sortingValue[value] == false) {
      this.sortingValue = {};
    }
    this.forumsType == 1 ? this.getData(this.urlConstructor('all')) : this.getMyForums(this.urlConstructor());
  }

  filter(e) {
    this.filterUrl = e;
    this.allPageData.current_page = 1;
    if (this.allPageDataMyForum?.current_page) {
      this.allPageDataMyForum['current_page'] = 1;
    }
    this.forumsType == 1 ? this.getData(this.urlConstructor('all')) : this.getMyForums(this.urlConstructor());
  }

}
