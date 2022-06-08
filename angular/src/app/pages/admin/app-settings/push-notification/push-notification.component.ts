import {Component, OnInit} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../../../shared/helper.service";
import {RequestService} from "../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {environment} from "../../../../../environments/environment.prod";

@Component({
  selector: 'app-push-notification',
  templateUrl: './push-notification.component.html',
  styleUrls: ['./push-notification.component.css'],
  animations: [
    trigger('openCloseView', [
      state('open', style({
        width: '558px',
        opacity: '1'
      })),
      state('closed', style({
        width: 0,
        opacity: '0'
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
    trigger('page', [
      state('open', style({
        opacity: '1',
        visibility: 'visible',
        position: 'absolute',
        zIndex: 10,
        width: '100%'
      })),
      state('closed', style({
        opacity: '0',
        visibility: 'hidden',
        position: 'absolute',
        zIndex: 5,
        width: '100%'
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
    trigger('openClose', [
      // ...
      state('open', style({
        width: 590,
        opacity: 1

      })),
      state('closed', style({
        opacity: 0

      })),

      state('openButton', style({
      })),
      state('closedButton', style({
        opacity: 0,
        visibility: 'hidden'
      })),

      transition('openButton <=> closedButton', [
        animate('0.5s linear')
      ]),

      state('openAnimations', style({
      })),
      state('closedAnimations', style({
        opacity: 0,
        margin: 0,
        padding: 0,
        visibility: 'hidden'
      })),

      transition('openAnimations <=> closedAnimations', [
        animate('0.5s linear')
      ]),

      state('closedIf', style({
        opacity: 0,
        visibility: 'hidden',
        width: '0%',
        height: 0,
        padding: 0,
        // display: 'none'
      })),

      state('openIf', style({
        width: '20%'
      })),

      transition('openIf <=> closedIf', [
        animate('0.5s linear')
      ]),

      state('chatClose', style({
        visibility: 'hidden',
        opacity: 0
      })),

      state('chatOpen', style({
        opacity: 1
      })),

      transition('chatOpen <=> chatClose', [
        animate('0.5s ease-in')
      ]),

      transition('open <=> closed', [
        animate('0.5s linear')
      ]),
    ]),
  ]
})
export class PushNotificationComponent implements OnInit {
  show = true;
  backPage = true;
  showPage = false; // true
  isOpen = false;
  bool = false;
  language: any;
  country: any;
  url: string = '';
  allPageData: any;
  data: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.translations.get}`
  }

  ngOnInit(): void {
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.data = items['data'] ? items['data'] : items;
      this.allPageData = items;
    })
  }

  close () {
    this.isOpen = false;
  }

}
