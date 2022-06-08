import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";

@Component({
  selector: 'app-push-notification-view',
  templateUrl: './push-notification-view.component.html',
  styleUrls: ['./push-notification-view.component.css']
})
export class PushNotificationViewComponent implements OnInit {
  @Output() myEvent = new EventEmitter();

  constructor(public helperService: HelperService) { }

  ngOnInit(): void {
  }

  close(){
    this.myEvent.emit('close')
  }

}
