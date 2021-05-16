import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {RequestService} from "../../shared/Service/request.service";
import {ActivatedRoute, Router} from "@angular/router";
import {environmentSocket} from "../../../environments/environment.prod";
import * as io from 'socket.io-client';
import {FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {Location, ViewportScroller} from '@angular/common';


@Component({
  selector: 'app-forum-group',
  templateUrl: './forum-group.component.html',
  styleUrls: ['./forum-group.component.scss']
})
export class ForumGroupComponent implements OnInit, OnDestroy {
  reply;
  forumData;
  socket: any;
  @ViewChild('scrollMe') private myScrollContainer: ElementRef;
  messageForm = this.fb.group({
    message: ['', Validators.required],
  });
  reply_id;
  level;
  reply_user_id;
  group_id;
  isShowReply: any = false;
  access: any = ['create', 'reply', 'delete'];
  socketUrl;

  constructor(public requestService: RequestService,
              public router: Router,
              private activeRoute: ActivatedRoute,
              private fb: FormBuilder,
              private alertService: AlertService,
              private _location: Location,
              private vps: ViewportScroller) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }


  ngOnInit() {
    if (this.requestService.reply) {
      this.reply = this.requestService.reply;
    }
    if (localStorage.getItem('access')) {
      this.access = JSON.parse(localStorage.getItem('access'))['forum_comment'] ? JSON.parse(localStorage.getItem('access'))['forum_comment'] : [];
    }

    if (this.activeRoute.snapshot.params['code'] == 'arm') {
      this.socketUrl = environmentSocket.socket_url_arm
    } else {
      this.socketUrl = environmentSocket.socket_url_geo
    }
    /*
      Connection parameters:
      Required parameter "key". This "key" is a access_token for connection authentication.
     */
    this.socket = io(this.socketUrl + '?key=' + localStorage.getItem('access_token'));
    /*
      Forum data config event
     */
    this.socket.on('connect', () => {
      let data = {
        "language_code": "en", // required, String or "hy"
        "forum_id": this.activeRoute.snapshot.params['id'], // required, int
        "comments_rows": 999999999,    // required, int
        "comments_page": 0      // required, int
      };

      /*
        To send a request to receive forum by forum_id, you need to send an event "SafeYOU_V4##FORUM_MORE_INFO".
       */
      this.socket.emit('SafeYOU_V4##FORUM_MORE_INFO', data);

      /*
        To get the forum you need create the event "SafeYOU_V4##FORUM_MORE_INFO#RESULT".
       */
      this.socket.on('SafeYOU_V4##FORUM_MORE_INFO#RESULT', (info) => {
        if (info.error == null) {
          this.forumData = info.data;
          this.forumData['comments'].sort(function (a, b) {
            if (a.id < b.id) return -1;
            if (a.id > b.id) return 1;
            return 0;
          });
          let temp = {};

          for (let i = 0; i < this.forumData['comments'].length; i++) {
            if (this.activeRoute.snapshot.params['group_id'] == this.forumData['comments'][i]['id']) {

              this.forumData['comments'][i]['reply'] = [];
              temp = this.forumData['comments'][i];
              temp['reply'] = [];
              for (let j = 0; j < this.forumData['reply_list'].length; j++) {
                if (this.forumData['reply_list'][j]['group_id'] == this.forumData['comments'][i]['group_id']) {
                  var x = this.forumData['reply_list'][j];
                  if (this.forumData['reply_list'][j]['level'] >= 2)
                    x['reply_name'] = this.find(x['reply_id']);
                  temp['reply'].push(x);
                }
              }


            }
          }
          if (Object.keys(temp).length == 0) {
            this._location.back();
          }
          if (temp.hasOwnProperty('reply'))
            temp['reply'].sort(function (a, b) {
              if (a.id < b.id) return -1;
              if (a.id > b.id) return 1;
              return 0;
            });

          this.forumData['comments'] = [temp];
        } else {}
      });

      /*
        To get the new comments you need create the event "SafeYOU_V4##ADD_NEW_COMMENT#RESULT".
       */
      this.socket.on('SafeYOU_V4##ADD_NEW_COMMENT#RESULT', (comment) => {
        if (comment.error == null) {
          this.forumData['reply_list'].push(comment.data);
          for (let i = 0; i < this.forumData['comments'].length; i++) {
            if (comment.data['group_id'] == this.forumData['comments'][i]['group_id']) {
              if (this.forumData['comments'][i]['reply'] == undefined) this.forumData['comments'][i]['reply'] = [];
              if (comment.data['level'] >= 2)
                comment.data['reply_name'] = this.find(comment.data['reply_id']);
              this.forumData['comments'][i]['reply'].push(
                comment.data
              )
            }
          }

          setTimeout(() => {
            this.scrollToBottom();
          }, 1);
        } else {
          this.router.navigate(['500']);
        }
      })

      /*
        To get the comments after delete comment you need create the event "SafeYOU_V4##DELETE_COMMENT#RESULT".
       */
      this.socket.on('SafeYOU_V4##DELETE_COMMENT#RESULT', (data) => {
        if (data.error) {
          this.router.navigate(['403']);
        }
      })

    });
    /*
      Server disconnect
     */
    this.socket.on('disconnect', (data) => {
      this.router.navigate(['500']);
    });
  }

  find(id) {
    for (let i = 0; i < this.forumData['comments'].length; i++) {
      if (this.forumData['comments'][i]['id'] == id)
        return this.forumData['comments'][i]['name'];
    }
    for (let i = 0; i < this.forumData['reply_list'].length; i++) {
      if (this.forumData['reply_list'][i]['id'] == id)
        return this.forumData['reply_list'][i]['name'];
    }

    return 'undefined';
  }

  replyComment(data, id) {
    this.reply = data;
    this.reply.id = data.id;
    this.reply.level = data.level ? data.level : data.level;
    this.reply.user_id = data.user_id;
    this.reply.group_id = data.group_id;
    this.vps.scrollToAnchor(id);
  }

  sendMessage(form) {
    let data = {
      "language_code": "en", // required, String or "hy"
      "forum_id": this.activeRoute.snapshot.params['id'], // required, int
      "messages": form.message, // required, long text
    };
    if (this.reply && this.reply.id !== undefined) {
      data['reply_id'] = this.reply.id; // not mandatory, int
    } else if (this.reply == undefined) {
      data['reply_id'] =  this.forumData['comments'][0].id; // not mandatory, int
    }
    if (this.reply && this.reply.user_id !== undefined) {
      data['reply_user_id'] = this.reply.user_id; // not mandatory, int
    } else if (this.reply == undefined) {
      data['reply_user_id'] =  this.forumData['comments'][0].user_id; // not mandatory, int
    }
    if (this.reply && this.reply.level == undefined) {
      data['level'] = 1; // required, int
    } else if (this.reply && this.reply.level != undefined) {
      data['level'] = this.reply.level + 1; // required, int
    } else if (this.reply == undefined) {
      data['level'] = 1; // required, int
    }
    if (this.reply && this.reply.group_id !== undefined) {
      data['group_id'] = this.reply.group_id; // required, int
    } else {
      data['group_id'] = this.activeRoute.snapshot.params['group_id']; // required, int
    }
    /*
      To get the new comments you need create the event "SafeYOU_V4##ADD_NEW_COMMENT".
     */
    this.socket.emit('SafeYOU_V4##ADD_NEW_COMMENT', data);
    this.reply_id = undefined;
    this.level = undefined;
    this.reply_user_id = undefined;
    this.reply = undefined;
    this.group_id = undefined;
    this.requestService.reply = undefined;
    this.messageForm.reset();
    this.scrollToBottom();
  }

  deleteComment(id, group_id) {
    let data = {
      id,
      group_id
    };
    /*
      To delete the comments you need create the event "SafeYOU_V4##DELETE_COMMENT".
     */
    this.socket.emit('SafeYOU_V4##DELETE_COMMENT', data);
    this.reply_id = undefined;
    this.level = undefined;
    this.reply_user_id = undefined;
    this.group_id = undefined;
    this.reply = undefined;
    this.requestService.reply = undefined;
  }

  /*
    Cancel reply
   */
  deleteReply() {
    this.reply_id = undefined;
    this.level = undefined;
    this.reply_user_id = undefined;
    this.group_id = undefined;
    this.reply = undefined;
    this.requestService.reply = undefined;
  }

  ngOnDestroy() {
    /*
      Disconnect all events and variables
     */
    this.reply_id = undefined;
    this.level = undefined;
    this.reply_user_id = undefined;
    this.group_id = undefined;
    this.reply = undefined;
    this.requestService.reply = undefined;
    this.forumData = undefined;
    this.socket.disconnect();
    this.socket.off('SafeYOU_V4##FORUM_MORE_INFO#RESULT');
    this.socket.off('SafeYOU_V4##ADD_NEW_COMMENT#RESULT');
    this.socket.off('SafeYOU_V4##DELETE_COMMENT#RESULT');
  }

  backClicked() {
    this._location.back();
  }


  scrollToBottom(): void {
    try {
      this.myScrollContainer.nativeElement.scrollTop = this.myScrollContainer.nativeElement.scrollHeight;
    } catch (err) {
    }
  }

}
