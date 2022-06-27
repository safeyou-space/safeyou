import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";

@Component({
  selector: 'app-help-messages-view',
  templateUrl: './help-messages-view.component.html',
  styleUrls: ['./help-messages-view.component.css']
})
export class HelpMessagesViewComponent implements OnInit {

  @Input() data;
  @Output() myEvent = new EventEmitter();

  constructor(public helperService: HelperService,) { }

  ngOnInit(): void {
  }

  close(){
    this.myEvent.emit('close')
  }

}
