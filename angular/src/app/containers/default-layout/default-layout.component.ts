import {
  Component,
  OnDestroy,
  Inject,
  AfterViewInit,
  OnInit,
  ChangeDetectorRef,
  ViewChild,
  ElementRef
} from '@angular/core';
import {DOCUMENT} from '@angular/common';
import {ActivatedRoute, Router} from "@angular/router";
import {Subscription} from "rxjs";
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";


@Component({
  selector: 'app-dashboard',
  templateUrl: './default-layout.component.html'
})
export class DefaultLayoutComponent implements OnDestroy, AfterViewInit, OnInit {
  public navItems;
  public sidebarMinimized = true;
  private changes: MutationObserver;
  public element: HTMLElement;
  public loading = false;
  subscriptionLoading: Subscription;
  dateObj: number = Date.now();
  dropdownValues: any = [];
  @ViewChild('dropdownList') dropdownList : ElementRef;

  constructor(
    private cdRef: ChangeDetectorRef,
    public requestService: RequestService,
    public activeRoute: ActivatedRoute,
    public router: Router,
    @Inject(DOCUMENT) _document?: any) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];


    this.changes = new MutationObserver((mutations) => {
      this.sidebarMinimized = _document.body.classList.contains('sidebar-minimized');
    });
    this.element = _document.body;
    this.changes.observe(<Element>this.element, {
      attributes: true,
      attributeFilter: ['class']
    });
  }

  ngOnInit() {
    this.requestService.getMenuList();
    this.subscriptionLoading = this.requestService.loading.subscribe((data) => {

      if (data && data['isLoading'] && data['reqCount'] === 1) {
        this.loading = data['isLoading'];
        this.cdRef.detectChanges();
      }
      if (data && data['reqCount'] === 0) {
        this.loading = data['isLoading'];
        this.cdRef.detectChanges();
      }


    });
  }

  onHidden(): void {
    console.log('Dropdown is hidden');
  }
  onShown(): void {
    console.log('Dropdown is shown');
  }
  isOpenChange(): void {
    console.log('Dropdown state is changed');
  }

  ngOnDestroy(): void {
    this.changes.disconnect();
  }

  ngAfterViewInit() {
    document.getElementsByClassName('navbar-toggler')[2].remove();
  }

   // clear localStorage logout and redirect to login page
  logOut() {
    this.requestService.createData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.logout}`, '').subscribe(res => {
      window.localStorage.clear();
      this.router.navigate([`administrator/${this.requestService.activeCountryCode}/login`]);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // send notification remove request
  removeNotification (id) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.contactUs.isRead}${id}`).subscribe((item) => {
      this.requestService.getNotificationList();
    }, (error)=> {
      this.requestService.StatusCode(error);
    })
  }
}
