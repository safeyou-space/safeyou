import {ChangeDetectorRef, Component, OnInit, SecurityContext, ViewChild} from '@angular/core';
import {translations} from "./translation";
import {Subscription} from "rxjs";
import {FormBuilder, Validators} from "@angular/forms";
import {BsModalService, ModalDirective} from "ngx-bootstrap/modal";
import {ActivatedRoute} from "@angular/router";
import {DomSanitizer} from "@angular/platform-browser";
import {RequestService} from "../../../shared/request.service";
import {environment} from "../../../../environments/environment.prod";

@Component({
  selector: 'app-geolocation',
  templateUrl: './geolocation.component.html',
  styleUrls: ['./geolocation.component.css']
})
export class GeolocationComponent implements OnInit {

  @ViewChild('childModal') childModal!: ModalDirective;
  @ViewChild('map') map;

  modalForm = this.fb.group({
    // phone: ['', Validators.compose([Validators.required, Validators.pattern(this.requestService.patterns.phone)])],
    uri: ['', Validators.compose([Validators.required])]
  });
  response: any;
  public loading = false;

  showChildModal(): void {
    this.childModal.show();
  }

  hideChildModal(): void {
    this.childModal.hide();
  }

  contactForm = this.fb.group({
    name: ['', Validators.compose([Validators.required, Validators.maxLength(120)])],
    email: ['', Validators.compose([Validators.required, Validators.maxLength(120), Validators.minLength(6), Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/)])],
    message: ['', Validators.compose([Validators.required, Validators.maxLength(500)])]
  });
  url: any;
  uri: any;
  country!: string;
  showPage: any = false;
  iframeUrl :any;
  subscriptionLoading!: Subscription;
  errorMessage: any;
  isSended: any = false;
  defaultlanguage: any = 'en';
  translation

  constructor(
    private fb: FormBuilder,
    private modalService: BsModalService,
    public activeRoute: ActivatedRoute,
    public sanitizer: DomSanitizer,
    private cdRef: ChangeDetectorRef,
    public requestService: RequestService)
  {
    // this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
    this.country = this.activeRoute.snapshot.params['code'];
    this.uri = this.activeRoute.snapshot.params['uri'];
  }

  ngOnInit() {
    this.url = `${environment.baseUrl}/${this.country}/${environment.web.geolocation.sendPhone}`;
    this.modalForm.patchValue({
      uri: this.uri
    });
    this.formSubmit(this.modalForm.value);
    // if (localStorage.getItem('phone')) {
    //   this.modalForm.patchValue({
    //     uri: this.uri,
    //     phone: localStorage.getItem('phone')
    //   });
    //   this.formSubmit(this.modalForm.value);
    // }
    // this.subscriptionLoading = this.requestService.loading.subscribe((data) => {
    //
    //   if (data && data['isLoading'] && data['reqCount'] === 1) {
    //     this.loading = data['isLoading'];
    //     this.cdRef.detectChanges();
    //   }
    //   if (data && data['reqCount'] === 0) {
    //     this.loading = data['isLoading'];
    //     this.cdRef.detectChanges();
    //   }
    //
    //
    // });
    this.translation = translations[this.defaultlanguage];
  }

  changelanguage(lang) {
    this.translation = translations[lang];
    this.defaultlanguage = lang;
  }


  carousel () {
    // $('#owl-example').owlCarousel({
    //   center: true,
    //   items:2,
    //   autoplay: true,
    //   loop: true,
    //   margin:10,
    //   responsive:{
    //     769:{
    //       items:4
    //     },
    //     576:{
    //       items:3
    //     }
    //   }
    // });
    // document.getElementById('iframe-map-block').scrollIntoView();
  }

  // openNav() {
  //   document.getElementById("mySidenav").style.width = "250px";
  //   document.getElementById("mySidenav").style.zIndex = "100";
  // }
  //
  // closeNav() {
  //   document.getElementById("mySidenav").style.width = "0";
  // }

  scroll(el: HTMLElement) {
    // this.closeNav();
    el.scrollIntoView();
  }
  onHidden(): void {
    this.modalForm.reset();
    this.childModal.hide();
  }

  formSubmit(form) {
    this.errorMessage = null;
    this.requestService.createData(`${this.url}`, form).subscribe((res: any) => {
      this.showPage = true;
      this.response = res;
      setTimeout(() => {
        this.iframeUrl = this.sanitizer.sanitize(SecurityContext.HTML,this.sanitizer.bypassSecurityTrustHtml("<iframe class='iframe-map' [property]=binding: src='https://maps.google.com/maps?q="+res.latitude+","+res.longitude+"&hl=es;z=14&amp;output=embed'></iframe>"));
        this.map.nativeElement.innerHTML = this.iframeUrl;
        localStorage.setItem('phone', form.phone);
        this.carousel();
      }, 200);
    }, error => {
      // this.requestService.StatusCode(error);
      // this.errorMessage = this.requestService.errorMessage;
    });
  }

  contactFormSubmit (form) {
    this.isSended = true;
    // let url = environment.endpoint + environment.contactUs.createContactUs;
    let url = `environment.endpoint + environment.contactUs.createContactUs;`
    this.requestService.createData(url, form.value).subscribe((item)=> {
      // this.alertService.success(item['message']);
      this.isSended = false;
      form.reset();
    }, (error)=> {
      this.isSended = false;
      // this.requestService.StatusCode(error)
    })
  }

  ngOnDestroy () {
    localStorage.removeItem('phone');
  }

}
