import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { io } from "socket.io-client";
import { apiUrlChat, environment } from "../../environments/environment.prod";
import { BehaviorSubject, Subject } from "rxjs";
import { RequestService } from './request.service';
import dateFormat from "dateformat";
import { Router } from '@angular/router';


@Injectable({
  providedIn: 'root'
})
export class SocketConnectionService {
  socket: any;
  userLists: any = [];
  rootInfo: any;
  active: any;
  activeLeave: boolean = false;
  itemList: any;
  messages: any = [];
  showPage = true;
  myUserId;

  onlineUsersCount: any = [];
  typing: any = {};
  scrollBottom = false;
  invokeEvent: Subject<boolean> = new BehaviorSubject<boolean>(false);
  forDashboard: Subject<boolean> = new BehaviorSubject<boolean>(false);
  callForum = false;
  userKey = {};
  forForumScroll = false;
  messageFromNotificationUrl;
  messageFromNotificationUrl2 = false;
  messageFromNotificationUrlPagination = false;

  usersJoinedOrLeave: any = [];
  openReplies = false;

  helpSignal: Subject<any> = new BehaviorSubject(false);
  notifications: Subject<any> = new BehaviorSubject(false);
  activeForumIdAndRoomKey = {};
  forums;

  response = 1;

  skyp = 0;
  loadPage = false;
  navigateForum: Subject<any> = new BehaviorSubject(false);
  newNotifications = <any>[];
  forBackAllComment = false;


  constructor(@Inject(PLATFORM_ID) private platformId: any, private requestService: RequestService, private router: Router) {

  }


  callMethodOfSecondComponent(userkEY?, user?) {
    this.callForum = false;
    if (userkEY) {
      this.userKey['userKey'] = userkEY;
      this.userKey['user'] = user;
    }

  }

  callForumChat(id) {
    this.callForum = true;
    this.openReplies = false;
    if (this.activeLeave !== false) {
      this.leaveAndJoinRoom(id);
    } else {
      this.joinRoom(id);
    }
  }


  connect() {
    if (this.socket) {
      this.socket.disconnect();
    }

    this.socket = io(environment.url + '?_=' + localStorage.getItem('access_token'));


    this.socket.on('connect', () => {
      localStorage.setItem('_', this.socket.id);
      this.invokeEvent.next(true);
      this.forDashboard.next(true);
      this.requestService.getData(apiUrlChat + '/api/notifications', true).subscribe(res => {
        this.notifications.next(res);
      })
    });
    this.socket.on('connect_error', (err) => {
    });
    this.socket.on('disconnect', () => {
      this.active = undefined;
      this.activeLeave = false;
      this.userLists = [];
      this.messages = [];
    });
    this.socket.on('signal', (signal_type, signal_data) => {
      if (signal_type == environment.SIGNAL_PROFILE) {
      } else if (signal_type == environment.SIGNAL_M_LIKED) {


        for (let message of this.messages) {
          if (message.message_id == signal_data['data'].like_message_id) {

            message.message_likes = message.message_likes.filter(res => res.like_user_id != signal_data['data'].user_id)
            message.message_likes.push(signal_data['data']);

          } else {
            for (let repli of message.message_replies) {
              if (repli.message_id == signal_data['data'].like_message_id) {

                repli.message_likes = repli.message_likes.filter(res => res.like_user_id != signal_data['data'].user_id)
                repli.message_likes.push(signal_data['data']);


              }
            }
          }
        }

      } else if (signal_type == environment.SIGNAL_R_INSERT) {
        this.usersListsPush(signal_data['data'], 'unshift');
      } else if (signal_type == environment.SIGNAL_R_UPDATE) {

      } else if (signal_type == environment.SIGNAL_R_DELETE) {
        for (let room of this.userLists) {
          if (room.room_id == signal_data['data'].room_id) {
            let indexJoined = this.userLists.indexOf(room);
            this.userLists.splice(indexJoined, 1);
          }
        }

      } else if (signal_type == environment.SIGNAL_M_DELETE) {

        for (let i = 0; i < this.messages.length; i++) {

          if (this.messages[i].message_id == signal_data['data'].message_id) {
            this.openReplies = false;
          }
          for (let j = 0; j < this.messages[i].message_replies.length; j++) {
            if (this.messages[i].message_replies[j].message_id == signal_data['data'].message_id) {
              this.messages[i].message_replies.splice(j, 1);
              if (this.messages[i].message_replies.length == 0) {
                this.openReplies = false;
              }
            }
          }

        }

        this.messages = this.messages.filter(res => res.message_id != signal_data['data'].message_id);
        for (let room of this.userLists) {
          if (room.room_id == signal_data['data'].room_id) {
            let room_last_message = this.messages[this.messages.length - 1];
            room.room_last_message = room_last_message;
          }
        }
      } else if (signal_type == environment.SIGNAL_M_UPDATE) {
        let ind = this.messages.findIndex(sms => sms.message_id == signal_data['data'].message_id);
        if (ind != -1) {
          signal_data['data'].time = new Date(signal_data['data'].message_updated_at).getDate() == new Date().getDate()
            ? dateFormat(new Date(signal_data['data'].message_updated_at), "HH:MM")
            : dateFormat(new Date(signal_data['data'].message_updated_at), "mmm d, yyyy h:MM");
          this.messages[ind] = signal_data['data'];
        } else {
          for (let i = 0; i < this.messages.length; i++) {
            for (let j = 0; j < this.messages[i].message_replies.length; j++) {
              if (signal_data['data'].message_id == this.messages[i].message_replies[j].message_id) {
                this.messages[i].message_replies[j] = signal_data['data'];
              }
            }
          }
        }

        for (let room of this.userLists) {
          if (room.room_id == signal_data['data'].message_room_id) {
            room['room_last_message'] = signal_data['data'];

            room['room_last_message'].time = new Date(signal_data['data'].message_updated_at).getDate() == new Date().getDate()
              ? dateFormat(new Date(signal_data['data'].message_updated_at), "HH:MM")
              : dateFormat(new Date(signal_data['data'].message_updated_at), "mmm d, yyyy h:MM");
            room['notificaton'] = signal_data['data'].message_send_by.user_id != this.myUserId ? true : false;
            room['typing'] = signal_data['data'].user_typing;

          }
        }
        this.typing['room_id'] = signal_data['data'].user_joined_room_id;
        this.typing['typing'] = signal_data['data'].user_typing;


      } else if (signal_type == environment.SIGNAL_M_INSERT) {
        this.socket.emit('signal', environment.SIGNAL_M_RECEIVED, {
          received_type: 1,
          received_message_id: signal_data['data'].message_id,
          received_room_id: this.active
        });

        for (let room of this.userLists) {
          if (room.room_id == signal_data['data'].message_room_id) {
            room['room_last_message'] = signal_data['data'];

            room['room_last_message'].time = new Date(signal_data['data'].message_created_at).getDate() == new Date().getDate()
              ? dateFormat(new Date(signal_data['data'].message_created_at), "HH:MM")
              : dateFormat(new Date(signal_data['data'].message_created_at), "mmm d, yyyy h:MM");
            room['notificaton'] = signal_data['data'].message_send_by.user_id != this.myUserId ? true : false;
            room['typing'] = signal_data['data'].user_typing;
          }
        }
        this.typing['room_id'] = signal_data['data'].user_joined_room_id;
        this.typing['typing'] = signal_data['data'].user_typing;


        if (signal_data['data'].message_room_id == this.active || signal_data['data'].message_room_key == this.active) {
          if (signal_data['data'].message_replied_message_id) {
            for (let i = 0; i < this.messages.length; i++) {
              if (signal_data['data'].message_replied_message_id == this.messages[i].message_id) {
                this.messages[i].message_replies.push(signal_data['data']);
              } else {
                for (let j = 0; j < this.messages[i].message_replies.length; j++) {
                  if (this.messages[i].message_replies[j].message_id == signal_data['data'].message_replied_message_id) {
                    this.messages[i].message_replies.push(signal_data['data']);
                  }
                }
              }
            }
          } else {
            this.messagesPush(signal_data['data']);
          }

          if (this.openReplies !== false && this.openReplies !== undefined && !signal_data['data'].message_replied_message_id) {
            this.openReplies = false;
          }

          if (document.getElementsByClassName('chat')[0].scrollTop + document.getElementsByClassName('chat')[0].clientHeight == document.getElementsByClassName('chat')[0].scrollHeight) {
            setTimeout(() => {
              document.getElementsByClassName('chat')[0].scrollTop = document.getElementsByClassName('chat')[0].scrollHeight;
            }, 0);
          }
        }

        if (signal_data['data']['message_send_by']['user_id'] == this.myUserId) {
          setTimeout(() => {
            if (document.getElementsByClassName('chat') && document.getElementsByClassName('chat')[0]) {
              document.getElementsByClassName('chat')[0].scrollTop = document.getElementsByClassName('chat')[0].scrollHeight;
            }
          }, 500);
        }
      } else if (signal_type == environment.SIGNAL_R_JOINED) {
        for (let room of this.userLists) {
          if (room.room_id == signal_data['data'].user_joined_room_id) {
            if (room.room_joined_users && room.room_joined_users.length > 0) {
              for (let joined of room.room_joined_users) {
                if (joined.user_id !== signal_data['data'].user_id) {
                  room.room_joined_users.push(signal_data['data']);
                }
              }
            } else {
              room.room_joined_users = [signal_data['data']];
            }
          }
        }

        let result = this.onlineUsersCount.filter(user_id => user_id == signal_data['data'].user_id);
        if (result.length == 0) {
          this.onlineUsersCount.push(signal_data['data'].user_id);
        }
      } else if (signal_type == environment.SIGNAL_R_LEAVED) {
        for (let room of this.userLists) {
          if (room.room_id == signal_data['data'].user_joined_room_id) {
            for (let joined of room.room_joined_users) {
              if (joined.user_id == signal_data['data'].user_id) {
                let indexJoined = room.room_joined_users.indexOf(joined);
                if (indexJoined > -1) {
                  room.room_joined_users.splice(indexJoined, 1);
                }
              }
            }
          }
        }
        let result = this.onlineUsersCount.filter(user_id => user_id == signal_data['data'].user_id);
        if (result.length != 0) {
          let index = this.onlineUsersCount.indexOf(signal_data['data'].user_id);
          this.onlineUsersCount.splice(index, 1);
        }
      } else if (signal_type == environment.SIGNAL_M_TYPING) {


        for (let room of this.userLists) {
          if (room.room_id == signal_data['data'].user_joined_room_id) {
            room['typing'] = signal_data['data'].user_typing;
          }
        }
        this.typing['room_id'] = signal_data['data'].user_joined_room_id;
        this.typing['typing'] = signal_data['data'].user_typing;
      } else if (signal_type == environment.SIGNAL_M_RECEIVED) {
        for (let message of this.messages) {
          if (message.message_id == signal_data['data'].receiver_message_id) {
            for (let i of message.message_receivers) {
              if (i.user_id == signal_data['data'].receiver_user_id) {
                i.received_type = signal_data['data'].receiver_received_type;
                if (i.received_type == 2) {

                  let ind = this.userLists.findIndex(res => res.room_id == message.message_room_id);
                  if (ind != -1) {
                    this.userLists[ind].notificaton = false;
                  }
                }
              }
            }
          }

        }

      } else if (signal_type == environment.SIGNAL_HELP) {
        this.helpSignal.next(signal_data['data']);
      } else if (signal_type == environment.SIGNAL_NOTIFICATIONMAIN) {
        if (this.forums && this.forums.length > 0) {
          for (let forum of this.forums) {
            if (forum.id == signal_data['data'].forum_id) {
              forum['comments_count'] = signal_data['data'].messages_count;
            }
          }
        }

      } else if (signal_type == environment.SIGNAL_NOTIFICATION) {

          this.newNotifications.unshift(signal_data['data']);
          const audio = new Audio("assets/audios/notification.wav");
          audio.play();
      }
    });


    this.invokeEvent.subscribe(value => {
      let url = this.router.url.split('/');
      let route = url[url.length - 1];
      if (route == 'communication' && value === true && this.socket.connected) {
        this.requestService.getData(environment.admin.communication + 'list?type=2', true).subscribe((res) => {
          this.userLists = [];
          for (let i = 0; i < res['data'].length; i++) {
            this.usersListsPush(res['data'][i], 'push');
          }
          if (this.userKey['userKey']) {
            localStorage.setItem('join_room_id', this.userKey['userKey']);
          } else {
            localStorage.setItem('join_room_id', res['data'][0]?.room_key);
          }
          this.active = localStorage.getItem('join_room_id');
          if (this.active != 'undefined' && this.active != undefined) {
            this.joinRoom();
          }
        });
        this.newRoom();
      }
    });

  }


  newRoom(bool?: boolean) {
    this.requestService.getData(environment.admin.friendsList + '?joint_room_type=2', true).subscribe((item) => {
      this.itemList = [];
      for (let i in item['data']) {
        this.itemList.push({
          id: item['data'][i].user_id,
          itemName: item['data'][i].user_username,
          image: (item['data'][i].user_image.includes("://") ? "" : this.requestService.imgPrefix) + item['data'][i].user_image,
          user_joint_rooms: item['data'][i].user_joint_rooms && item['data'][i].user_joint_rooms[0] ? item['data'][i].user_joint_rooms[0] : ''
        })
      }
      if (bool) {
        this.showPage = false;
      }
    })
  }

  usersListsPush(data, type) {
    this.userLists[type]({
      room_key: data.room_key,
      room_id: data.room_id,
      room_name: data.room_name,
      room_image: data.room_image,
      room_last_message: data.room_last_message,
      room_joined_users: data.room_joined_users,
      message_content: data.room_last_message?.message_content,
      time: data.room_last_message ? new Date(data.room_last_message?.message_updated_at).getDate() == new Date().getDate()
        ? dateFormat(new Date(data.room_last_message?.message_updated_at), "HH:MM")
        : dateFormat(new Date(data.room_last_message?.message_updated_at), "mmm d, yyyy h:MM") :
        new Date(data.room_updated_at).getDate() == new Date().getDate()
          ? dateFormat(new Date(data.room_updated_at), "HH:MM")
          : dateFormat(new Date(data.room_updated_at), "mmm d, yyyy h:MM")
    })
  }

  messagesPush(data, type?) {
    let method = type ? type : 'push';
    this.messages[method]({
      message_room_id: data.message_room_id,
      message_id: data.message_id,
      message_receivers: data.message_receivers,
      message_send_by: data.message_send_by,
      message_files: data.message_files,
      message_replies: data?.message_replies,
      message_likes: data?.message_likes,
      message_is_owner: data?.message_is_owner,
      message_content: data.message_content,
      time: new Date(data.message_updated_at).getDate() == new Date().getDate()
        ? dateFormat(new Date(data.message_updated_at), "HH:MM")
        : dateFormat(new Date(data.message_updated_at), "mmm d, yyyy h:MM")
    })
  }

  joinRoom(roomId?) {
    this.skyp = 0;
    this.response = 1;
    this.messages = [];
    this.active = roomId ? roomId : this.active;
    this.requestService.getData(environment.admin.communication + this.active + '/join', true).subscribe((k) => {
      this.activeLeave = true;
      this.rootInfo = k['data'];
      this.showPage = true;
      this.active = this.rootInfo.room_key;
      this.activeForumIdAndRoomKey['forumId'] = k['data']['room_target_id'];
      this.activeForumIdAndRoomKey['roomKey'] = k['data']['room_key'];

      localStorage.setItem('join_room_id', k['data']['room_key']);
      this.onlineUsersCount = [];
      for (let o = 0; o < this.rootInfo.room_joined_users.length; o++) {
        this.onlineUsersCount.push(this.rootInfo.room_joined_users[o].user_id);
      }
      let url = this.messageFromNotificationUrl ? this.messageFromNotificationUrl : environment.admin.communication + this.active + '/messages/list?skip=0&limit=30';

      if (this.messageFromNotificationUrl) {
        this.messageFromNotificationUrlPagination = false;
      } else {
        this.messageFromNotificationUrlPagination = true;
      }

      this.requestService.getData(url, true).subscribe((item) => {
        for (let i = 0; i < item['data'].length; i++) {
          this.messagesPush(item['data'][i]);
          if (this.messageFromNotificationUrl) {
              this.messageFromNotificationUrl2 = true;
              if (item['data'][i].message_replies.length > 0) {
                this.openReplies = item['data'][i].message_id;
              }
          }
        }

        setTimeout(() => {
          this.scrollBottom = true;
          this.forForumScroll = true;
        }, 0);
        this.messageFromNotificationUrl = undefined;
      });
    }, error => {
      this.activeLeave = false;
      this.messageFromNotificationUrl = undefined;
      if ((error == 'undefined' || error == undefined) && this.userKey['user']) {


        let fData = new FormData();
        fData.append('room_name', this.userKey['user'].user_username);
        fData.append('room_image', this.userKey['user'].user_image);
        fData.append('room_member[0]', this.userKey['user'].user_id);
        fData.append('room_type', '2');

        this.requestService.createData(environment.admin.communication + 'create', fData, true).subscribe((res) => {
          this.leaveAndJoinRoom(res['data'].room_key);
        })


      }
    });
  }


  getMessages(skyp) {
    if (this.active)
      this.requestService.getData(environment.admin.communication + this.active + '/messages/list?skip=' + skyp + '&limit=30', true).subscribe((item) => {
        if (item['data'].length == 0) {
          this.response = 0;
        } else {
          for (let i = 0; i < item['data'].length; i++) {
            this.messagesPush(item['data'][i], 'unshift');
          }
          this.response = 1;
          this.loadPage = true;
          this.scrollIntoLoadDiv(item['data'].length - 1);

        }

      });
  }


  leaveAndJoinRoom(room_key) {
    this.showPage = true;
    this.response = 1;
    this.skyp = 0;
    this.messages = [];
    let url = environment.admin.communication + this.active + '/leave';
    this.active = undefined;

    if (this.activeLeave !== false) {
      if (this.active != room_key || this.callForum)
        this.requestService.getData(url, true).subscribe((i) => {
          this.joinRoom(room_key);
        });
    } else {
      this.joinRoom(room_key);
    }
  }


  scrollIntoLoadDiv(index) {

    new Promise((resolve) => {
      setTimeout(() => {
        resolve(true);
      }, 0);
    }).then((val) => {
      if (val) {

        let div = document.getElementById('divViewId' + index);

        if (div) {
          document.getElementsByClassName('chat')[0].scrollTop = div.offsetTop;
        }

        setTimeout(() => {
          this.loadPage = false;
        }, 0);
      }
    })
  }


}
