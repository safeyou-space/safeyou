import {Component, Input, OnInit} from '@angular/core';

@Component({
  selector: 'app-rate-stars',
  templateUrl: './rate-stars.component.html',
  styleUrls: ['./rate-stars.component.css']
})
export class RateStarsComponent implements OnInit {

  @Input() rating;
  constructor() { }

  ngOnInit(): void {
  }

}
