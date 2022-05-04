import {Component, EventEmitter, Input, OnInit, Output, ViewChild} from '@angular/core';
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-rating-view',
  templateUrl: './rating-view.component.html',
  styleUrls: ['./rating-view.component.css']
})
export class RatingViewComponent implements OnInit {

  @Input() data: any;
  @ViewChild('ratingModal') modal: any;
  @Output() closeRating = new EventEmitter();
  singleValue: any;

  constructor(public helperService: HelperService) { }

  ngOnInit(): void {
  }

  close () {
    this.closeRating.emit('close')
  }

  openModal (value) {
    this.modal.showModal();
    this.singleValue = value;
  }
}
