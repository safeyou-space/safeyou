import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {RequestService} from "../../shared/Service/request.service";
import * as io from 'socket.io-client';
import {environmentSocket} from "../../../environments/environment.prod";
import {ActivatedRoute, Router} from "@angular/router";
import {FormBuilder, Validators} from "@angular/forms";


@Component({
  selector: 'app-forum-data',
  templateUrl: './forum-data.component.html',
  styleUrls: ['./forum-data.component.scss']
})
export class ForumDataComponent implements OnInit, OnDestroy {
  socket: any;
  forumData = [];
  messageForm = this.fb.group({
    message: ['', Validators.required],
  });
  @ViewChild('scrollMe') private myScrollContainer: ElementRef;
  reply_id;
  level;
  reply_user_id;
  group_id;
  reply;
  isShowReply: any = false;
  access: any = ['create', 'reply', 'delete'];
  socketUrl;

  constructor(
    public requestService: RequestService,
    private route: ActivatedRoute,
    private fb: FormBuilder,
    public activeRoute: ActivatedRoute,
    public el: ElementRef,
    public router: Router) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
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
        "forum_id": this.route.snapshot.params['id'], // required, int
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
          for (let i = 0; i < this.forumData['comments'].length; i++) {
            this.forumData['comments'][i]['reply'] = [];
            for (let j = 0; j < this.forumData['reply_list'].length; j++) {
              if (this.forumData['reply_list'][j]['group_id'] == this.forumData['comments'][i]['group_id']) {
                this.forumData['comments'][i]['reply'].push(
                  this.forumData['reply_list'][j]
                )
              }
            }
            this.forumData['comments'][i]['reply'].sort(function (a, b) {
              if (a.id < b.id) return -1;
              if (a.id > b.id) return 1;
              return 0;
            });
          }
        } else {
          console.log('error')
        }
      });

      /*
        To get the new comments you need create the event "SafeYOU_V4##ADD_NEW_COMMENT#RESULT".
       */
      this.socket.on('SafeYOU_V4##ADD_NEW_COMMENT#RESULT', (comment) => {
        if (comment.error == null) {
          if (comment.data['reply_id'] != null) {
            for (let i = 0; i < this.forumData['comments'].length; i++) {
              if (comment.data['group_id'] == this.forumData['comments'][i]['group_id']) {
                if (this.forumData['comments'][i]['reply'] == undefined) this.forumData['comments'][i]['reply'] = [];
                this.forumData['comments'][i]['reply'].push(
                  comment.data
                )
              }
            }
          } else {
            this.forumData['comments'].push(comment.data);
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

  /*
    Reply comment navigation
   */
  replyComment(data) {
    this.requestService.reply = data;
    this.router.navigate(
      [`administrator/${this.requestService.activeCountryCode}/forum/${this.route.snapshot.params['id']}/forum-group/${data.group_id}`]
    );
  }

  sendMessage(form) {
    let data = {
      "language_code": "en", // required, String or "hy"
      "forum_id": this.route.snapshot.params['id'], // required, int
      "messages": form.message, // required, long text
    };
    if (this.reply_id !== undefined) {
      data['reply_id'] = this.reply_id; // not mandatory, int
    }
    if (this.reply_user_id !== undefined) {
      data['reply_user_id'] = this.reply_user_id; // not mandatory, int
    }
    if (this.level == undefined) {
      data['level'] = 0; // required, int
    } else {
      data['level'] = this.level + 1; // required, int
    }
    if (this.group_id !== undefined) {
      data['group_id'] = this.group_id; // required, int
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
  }

  /*
    Navigation for writing comment
   */
  commentPage(value) {
    this.router.navigate(
      [`administrator/${this.requestService.activeCountryCode}/forum/${this.route.snapshot.params['id']}/forum-group/${value}`]
    );

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
  }

  ngOnDestroy() {
    /*
      Disconnect all events
     */
    this.socket.disconnect();
    this.socket.off('SafeYOU_V4##FORUM_MORE_INFO#RESULT');
    this.socket.off('SafeYOU_V4##ADD_NEW_COMMENT#RESULT');
    this.socket.off('SafeYOU_V4##DELETE_COMMENT#RESULT');
  }

  scrollToBottom(): void {
    try {
      this.myScrollContainer.nativeElement.scrollTop = this.myScrollContainer.nativeElement.scrollHeight;
    } catch (err) {
    }
  }
}
