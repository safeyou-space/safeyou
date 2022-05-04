import {Component, Input, OnInit} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";
import {RequestService} from "../../../../../shared/request.service";
import {ConsultantsComponent} from "../consultants.component";

@Component({
  selector: 'app-consultants-view',
  templateUrl: './consultants-view.component.html',
  styleUrls: ['./consultants-view.component.css']
})
export class ConsultantsViewComponent implements OnInit {

  @Input() data;

  constructor(public helperService: HelperService,
              public requestService: RequestService) { }

  ngOnInit(): void {
  }


  editData(id) {
    ConsultantsComponent.instance.callSubmit('Edit', id);
  }

}
