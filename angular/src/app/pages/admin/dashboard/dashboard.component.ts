import {Component, OnDestroy, OnInit} from '@angular/core';
import {HelperService} from "../../../shared/helper.service";
import {ActivatedRoute, Router} from "@angular/router";
import {RequestService} from "../../../shared/request.service";
import {apiUrlChat, environment} from "../../../../environments/environment.prod";
import {SocketConnectionService} from "../../../shared/socketConnection.service";
import dateFormat from "dateformat";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
})
export class DashboardComponent implements OnInit, OnDestroy {
  dashboard: any;
  language: any = location.pathname.split('/')[1];
  country: any = location.pathname.split('/')[0];
  myMessages: any = [];
  imgUrl = apiUrlChat;
  dashboardSubject: any;
  newMessageListSubject: any;
  is_super_admin: any;

  constructor(public helperService: HelperService,
              public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              private router: Router,
              public socketConnect: SocketConnectionService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.helperService.defaultLanguage = this.language;
  }

  ngOnInit(): void {
    this.is_super_admin = JSON.parse(localStorage.getItem( 'is_super_admin')!);
    this.helperService.userName = `${localStorage.getItem('first_name')}`;
    this.helperService.userLastName = `${localStorage.getItem('last_name')}`;
    this.helperService.userEmail = `${localStorage.getItem('email')}`;
    this.helperService.userImage = `${localStorage.getItem('image')}`;
    this.getDashboard();
    this.getCommunication();
    this.getNewMessagesList();
  }

  getDashboard() {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.dashboard}`).subscribe((res) => {
      this.dashboard = res;
    })
  }

  navigateCommunication (key) {
    this.socketConnect.callMethodOfSecondComponent(key);
    let url = `/${this.country}/${this.helperService.defaultLanguage}/communication`;
    this.router.navigate([url]);
  }

  getCommunication() {


    this.dashboardSubject = this.socketConnect.forDashboard.subscribe(res => {
      if (res) {
        this.requestService.getData(environment.admin.communication + 'list?type=2', true).subscribe((res) => {

          let myMessages = res['data'].splice(0,2);
          this.myMessages.splice(0);

          for (let i = 0; i < myMessages.length; i++) {
            this.myMessages.push({
              room_key: myMessages[i].room_key,
              room_id: myMessages[i].room_id,
              room_name: myMessages[i].room_name,
              room_image: myMessages[i].room_image,
              room_last_message: myMessages[i].room_last_message,
              room_joined_users: myMessages[i].room_joined_users,
              message_content: myMessages[i].room_last_message?.message_content,
              time: myMessages[i].room_last_message ? new Date(myMessages[i].room_last_message?.message_updated_at).getDate() == new Date().getDate()
                ? dateFormat(new Date(myMessages[i].room_last_message?.message_updated_at), "HH:MM")
                : dateFormat(new Date(myMessages[i].room_last_message?.message_updated_at), "mmm d, yyyy h:MM") :
                new Date(myMessages[i].room_updated_at).getDate() == new Date().getDate()
                  ? dateFormat(new Date(myMessages[i].room_updated_at), "HH:MM")
                  : dateFormat(new Date(myMessages[i].room_updated_at), "mmm d, yyyy h:MM")
            })
          }
        });

      }
    })

  }

  getNewMessagesList () {
    this.newMessageListSubject = this.socketConnect.forDashboardNewMessageList.subscribe((res:any) => {
      if (res) {
        let data = {
          new_message: true,
          room_key: res.message_room_key,
          room_id: res.message_room_id,
          room_name: res.message_send_by.user_username,
          room_image: res.message_send_by.user_image,
          room_last_message: res,
          // room_joined_users: res.room_joined_users,
          message_content: res?.message_content,
          time: res ? new Date(res?.message_updated_at).getDate() == new Date().getDate()
            ? dateFormat(new Date(res?.message_updated_at), "HH:MM")
            : dateFormat(new Date(res?.message_updated_at), "mmm d, yyyy h:MM") :
            new Date(res.room_updated_at).getDate() == new Date().getDate()
              ? dateFormat(new Date(res.message_created_at), "HH:MM")
              : dateFormat(new Date(res.message_created_at), "mmm d, yyyy h:MM")
        }
        this.myMessages.pop();
        this.myMessages.unshift(data);
      }
    })
  }

  ngOnDestroy() {
    this.dashboardSubject.unsubscribe();
  }

  viewForum(item) {
    this.router.navigate([this.country + '/' + this.helperService.defaultLanguage + '/forum']);
    setTimeout(() => {
      this.helperService.getNavigateForum(item);
    },0);
  }

}
