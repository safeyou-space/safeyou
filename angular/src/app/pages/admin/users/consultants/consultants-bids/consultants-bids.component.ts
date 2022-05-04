import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";
import {RequestService} from "../../../../../shared/request.service";
import {environment} from "../../../../../../environments/environment.prod";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-consultants-bids',
  templateUrl: './consultants-bids.component.html',
  styleUrls: ['./consultants-bids.component.css']
})
export class ConsultantsBidsComponent implements OnInit {

  @Input() data;
  @Output() myEvent = new EventEmitter();
  @Output() getRequest = new EventEmitter();
  language: any;
  country: any;
  suggestedCategory: any;

  constructor(public helperService: HelperService,
              public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              ) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
  }

  close(type){
    this.myEvent.emit('close');
  }

  changeStatus(status) {
    if (status == 1) {
      if (this.data.suggested_category && !this.data.category) {
        // this.getLanguageListFromCategory('category');
        this.suggestedCategory = this.data.suggested_category;
      } else {
        this.sendStatusRequest(status);
      }
    } else {
      this.sendStatusRequest(status);
    }
  }

  sendStatusRequest(status) {
    let value = {
      status: status,
      category_id: this.data.category.id
    }
    let url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}`;
    this.requestService.updateData(url, value, this.data.id).subscribe((items) => {
      this.getItemData();
      this.getRequest.emit(true);
    })
  }

  getItemData() {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}/${this.data.id}`).subscribe((item) => {
     this.data = item[0];
    })
  }

}
