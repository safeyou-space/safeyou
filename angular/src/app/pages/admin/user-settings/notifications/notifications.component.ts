import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { SocketConnectionService } from 'src/app/shared/socketConnection.service';
import { apiUrl } from 'src/environments/environment.prod';
import {HelperService} from "../../../../shared/helper.service";

@Component({
  selector: 'app-notifications',
  templateUrl: './notifications.component.html',
  styleUrls: ['./notifications.component.css']
})
export class NotificationsComponent implements OnInit {
  imageUrl = apiUrl;
  notifications;
  language: any;
  country: any;
  constructor(public helperService: HelperService, public activateRoute: ActivatedRoute, public socketConnect: SocketConnectionService, private router: Router) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
   }

  ngOnInit(): void {

    this.socketConnect.notifications.subscribe(res => {
      if (res) {
        this.notifications = res['data'];
      }

    })

  }

  getter(notification, type?) {
    this.socketConnect.socket.emit('signal', 18, {
      notify_id: notification.notify_id
    });
    for (let not of this.notifications) {
        if (not.notify_id == notification.notify_id) {
            not.notify_read = 1;
        }
    }

    if (type == 'new') {
    
      if (notification.body.message_id) {
        this.socketConnect.newNotifications = this.socketConnect.newNotifications.filter(res => res.body.message_id != notification.body.message_id);
      } else {
        this.socketConnect.newNotifications = this.socketConnect.newNotifications.filter(res => res.body.id != notification.body.id);
      }
      
    }

    this.socketConnect.navigateForum.next(notification);
    this.router.navigateByUrl(`${this.country}/${this.language}/forum`);
  }

  getMinutes(paramDate) {
    let current = new Date();
    let old = new Date(paramDate);
    let days = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000 * 3600 * 24));
    let h = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000 * 3600));
    let m = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000 * 60));
    let s = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000));
    let year = Math.floor(days / 365);
    let months = Math.floor((days - (year * 365)) / 30);
    if (m > 0 && m < 60) {
      return m +  ' ' + this.helperService.translation?.minute
    } else if (m < 1) {
      return s + ' ' + this.helperService.translation?.second;
    } else {
      days -= 1;

      if (year > 0) {
        return year + ' ' + this.helperService.translation?.year;
      } else if (days > 30) {
        return months + ' ' + this.helperService.translation?.month;
      } else {
        if (days == 0) {
          return h + ' ' + this.helperService.translation?.time.toLowerCase();
        }
        return days + ' ' + this.helperService.translation?.day;
      }
    }

  }

}
