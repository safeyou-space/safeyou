import {Component, ElementRef, Inject, OnInit, ViewChild} from '@angular/core';
import {FormBuilder, Validators} from "@angular/forms";
import {ModalDirective} from "ngx-bootstrap/modal";
import {ActivatedRoute} from "@angular/router";
import  {translations} from "./translation";
import {OwlOptions} from "ngx-owl-carousel-o";
import {DOCUMENT} from "@angular/common";

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  @ViewChild('autoShownModal', { static: false }) autoShownModal?: ModalDirective;
  @ViewChild('mySidenav') mySidenav;
  isModalShown = false;
  contactForm = this.fb.group({
    name: ['', Validators.compose([Validators.required, Validators.maxLength(120)])],
    email: ['', Validators.compose([Validators.required, Validators.maxLength(120), Validators.minLength(6), Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/)])],
    message: ['', Validators.compose([Validators.required, Validators.maxLength(500)])]
  });
  isSended: any = false;
  defaultlanguage: any = 'en';
  translation;
  dateObj: number = Date.now();
  customOptions: OwlOptions = {
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
  };
  slidesStore = [
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-31.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-37.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-38.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-42.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-45.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-46.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-47.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-48.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-49.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-50.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-23-51.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-27-06.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_17-27-07.jpg',
    '/assets/pageImages/carousel-images/viber_image_2020-06-16_21-11-48.jpg'
  ];

  constructor(
              private fb: FormBuilder,
              public activeRoute: ActivatedRoute,
              @Inject(DOCUMENT) private document: Document,
              public element: ElementRef
              ) { }

  ngOnInit(): void {
    this.translation = translations[this.defaultlanguage];
  }

  changelanguage(lang) {
    this.translation = translations[lang];
    this.defaultlanguage = lang;
  }
  openNav() {
    this.mySidenav.nativeElement.style.width = "250px";
    this.mySidenav.nativeElement.style.zIndex = "100";
  }

  closeNav() {
    this.mySidenav.nativeElement.style.width = "0";
  }

  scroll(el: HTMLElement) {
    this.closeNav();
    el.scrollIntoView();
  }

  formSubmit (form) {

  }

  showModal(): void {
    this.isModalShown = true;
  }

  hideModal(): void {
    this.autoShownModal?.hide();
  }

  onHidden(): void {
    this.isModalShown = false;
  }
}
