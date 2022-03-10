import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../shared/request.service";
import {HelperService} from "../../../shared/helper.service";
import {FormBuilder} from "@angular/forms";

@Component({
  selector: 'app-podcast',
  templateUrl: './podcast.component.html',
  styleUrls: ['./podcast.component.css']
})
export class PodcastComponent implements OnInit {
  url: any;
  language: any;
  country: any;

  constructor(public activateRoute: ActivatedRoute,
              private requestService: RequestService,
              public helperService: HelperService,
              private fb: FormBuilder) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
  }

}
