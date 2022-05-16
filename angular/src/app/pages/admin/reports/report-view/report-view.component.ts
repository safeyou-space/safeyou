import {Component, OnInit, Output, EventEmitter, Input} from '@angular/core';
import {RequestService} from "../../../../shared/request.service";
import {HelperService} from "../../../../shared/helper.service";

@Component({
  selector: 'app-report-view',
  templateUrl: './report-view.component.html',
  styleUrls: ['./report-view.component.css']
})
export class ReportViewComponent implements OnInit {

  @Input() data;
  @Output() myEvent = new EventEmitter();
  constructor(public requestService: RequestService,
              public helperService: HelperService) { }

  ngOnInit(): void {
  }

  close(){
    this.myEvent.emit('close')
  }
}
