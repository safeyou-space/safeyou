import {Component, Input, OnInit, ViewChild} from '@angular/core';
import {HelperService} from "../../../shared/helper.service";
import {RequestService} from "../../../shared/request.service";
import {ModalDirective} from "ngx-bootstrap/modal";
import {environment} from "../../../../environments/environment.prod";

@Component({
  selector: 'app-rating-modal',
  templateUrl: './rating-modal.component.html',
  styleUrls: ['./rating-modal.component.css']
})
export class RatingModalComponent implements OnInit {

  isModalShown = false;
  itemList: any;
  @Input() data: any;
  date = new Date();
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;

  constructor(public helperService: HelperService,
              public requestService: RequestService,
              private request: RequestService) { }

  ngOnInit(): void {
  }

  hideModal(): void {
    this.autoShownModal.hide();
  }

  onHidden(): void {
    this.isModalShown = false;
  }

  showModal(): void {
    this.isModalShown = true;
  }

}
