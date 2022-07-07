import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-translations-view',
  templateUrl: './translations-view.component.html',
  styleUrls: ['./translations-view.component.css']
})
export class TranslationsViewComponent implements OnInit {
  @Output() myEvent = new EventEmitter();
  @Input() viewData;
  language: any;
  myObject = Object;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,) {
    this.language = this.activateRoute.snapshot.params['language'];
  }

  ngOnInit(): void {
  }

  close(){
    this.myEvent.emit('close')
  }

}
