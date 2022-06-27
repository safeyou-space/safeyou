import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";

@Component({
  selector: 'app-settings-view',
  templateUrl: './settings-view.component.html',
  styleUrls: ['./settings-view.component.css']
})
export class SettingsViewComponent implements OnInit {
  @Input() data;
  @Output() myEvent = new EventEmitter();

  constructor(public helperService: HelperService,) { }

  ngOnInit(): void {
  }

  close(){
    this.myEvent.emit('close')
  }

}
