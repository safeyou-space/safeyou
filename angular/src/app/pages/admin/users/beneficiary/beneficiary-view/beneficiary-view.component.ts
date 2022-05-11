import {Component, EventEmitter, Input, OnInit, Output, ViewChild} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";
import {RequestService} from "../../../../../shared/request.service";
import {ModalDirective} from "ngx-bootstrap/modal";

@Component({
  selector: 'app-beneficiary-view',
  templateUrl: './beneficiary-view.component.html',
  styleUrls: ['./beneficiary-view.component.css']
})
export class BeneficiaryViewComponent implements OnInit {

  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  isModalShown = false;
  @Input() data;
  @Input() type;
  @Output() myEvent = new EventEmitter();

  viewItem: any;
  index: any;
  record: any;

  constructor(public helperService: HelperService,public requestService: RequestService,) { }

  ngOnInit(): void {
  }

  close(){
    this.myEvent.emit('close');
  }
  showItem(item, i) {
    this.index = i;
    this.viewItem = item;
  }

  showModal(item): void {
    this.isModalShown = true;
    this.record = item;
  }

  hideModal(): void {
    this.autoShownModal.hide();
    setTimeout(() => {
      this.isModalShown = false;
    }, 0)
  }

  onHidden(): void {
    this.isModalShown = false;
  }
}
