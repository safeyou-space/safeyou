import {Component, OnInit, ViewChild} from '@angular/core';
import {AlertService} from "ngx-alerts";
import {FormBuilder, Validators} from "@angular/forms";
import {ModalDirective} from "ngx-bootstrap";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";
import  {translations} from "./translation";

declare var $;
declare var jQuery:any;
@Component({
  selector: 'app-safe-you-view',
  templateUrl: './safe-you-view.component.html',
  styleUrls: ['./safe-you-view.component.scss']
})
export class SafeYouViewComponent implements OnInit {

  @ViewChild('childModal') childModal: ModalDirective;
  contactForm = this.fb.group({
    name: ['', Validators.compose([Validators.required, Validators.maxLength(120)])],
    email: ['', Validators.compose([Validators.required, Validators.maxLength(120), Validators.minLength(6), Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/)])],
    message: ['', Validators.compose([Validators.required, Validators.maxLength(500)])]
  });
  url: any = environment.endpoint + environment.contactUs.createContactUs;
  isSended: any = false;
  requestType: any;
  defaultlanguage: any = 'en';
  translation;

  hideChildModal(): void {
    this.childModal.hide();
  }

  constructor(private alertService: AlertService,
              private fb: FormBuilder,
              public activeRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    this.translation = translations[this.defaultlanguage];
  }
  // change language function
   changeLanguage(lang) {
    this.translation = translations[lang];
     this.defaultlanguage = lang;
   }

  ngAfterViewInit () {
    // set slider options
        $('#owl-example').owlCarousel({
          center: true,
          items:2,
          autoplay: true,
          loop: true,
          margin:10,
          responsive:{
            769:{
              items:4
            },
            576:{
              items:3
            }
          }
        });
  }

  // open mobile menu
  openNav() {
    document.getElementById("mySidenav").style.width = "250px";
    document.getElementById("mySidenav").style.zIndex = "100";
  }

  // close mobile menu
  closeNav() {
    document.getElementById("mySidenav").style.width = "0";
  }

  // scroll to target element
  scroll(el: HTMLElement) {
    this.closeNav();
    el.scrollIntoView();
  }

  // send create or edit request
  formSubmit (form) {
    this.isSended = true;
    this.requestService.createData(this.url, form.value).subscribe((item)=> {
      this.alertService.success(item['message']);
      this.isSended = false;
      form.reset();
    }, (error)=> {
      this.isSended = false;
      this.requestService.StatusCode(error)
    })
  }

  // open modal function
  showModal (type) {
    this.requestType = type;
    this.childModal.show();
  }
}
