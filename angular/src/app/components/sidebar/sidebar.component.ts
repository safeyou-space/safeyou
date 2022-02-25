import {Component, EventEmitter, OnInit, Output, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css'],
  animations: [
    trigger('openClose', [
      state('open', style({
        opacity: 1,
        top: '40px',
        visibility: 'visible',
        width: '100%'
      })),
      state('closed', style({
        height: 0,
        opacity: 0,
        paddingTop: 0,
        paddingBottom: 0,
        visibility: 'hidden'
      })),
      state('parents-closed', style({
        height: 0,
        opacity: 0,
        paddingTop: 0,
        paddingBottom: 0,
        visibility: 'hidden'
      })),
      state('parents-open', style({
        opacity: 1,
        visibility: 'visible',
      })),
      transition('open <=> closed', [
        animate('0.4s ease-in-out')
      ]),
      transition('parents-closed <=> parents-open', [
        animate('0.4s ease-in-out')
      ]),
    ]),
    trigger('showMenu', [
      state('open', style({
        opacity: 1,
        left: 0,
        visibility: 'visible',
      })),
      state('closed', style({
        opacity: 0,
        left: '-272px',
        visibility: 'hidden'
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ])
  ]
})
export class SidebarComponent implements OnInit {
  @Output() sidebarMin = new EventEmitter();
  @ViewChild('sidebar') sidebar;
  @ViewChild('menu') menu;
  isOpen = 0;
  showMenu = true;
  language: any = location.pathname.split('/')[1];
  country: any = location.pathname.split('/')[0];
  access: any = [];
  is_admin: any;
  role: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute) {
    this.language = location.pathname.split('/')[2];
    this.country = location.pathname.split('/')[1];
  }

  ngOnInit(): void {
    this.access = JSON.parse(localStorage.getItem( 'access')!);
    this.is_admin = JSON.parse(localStorage.getItem( 'is_admin')!);
    this.role = localStorage.getItem('role')!;
    this.helperService.menuItem.subscribe((value) => {
      if (value && this.showMenu) {
        this.showMenu = !this.showMenu;
      } else if (value == false) {
        this.showMenu = true;
      }
      setTimeout(() => {
        if (this.sidebar.nativeElement.classList.contains('sidebar-min') && value) {
          this.toggleMenu(this.sidebar.nativeElement, this.menu.nativeElement);
        }
      }, 0);
    })
  }

  toggleMenu (sidebar, menu) {
      sidebar.classList.toggle("sidebar-min");
      menu.classList.toggle("ps");
      this.sidebarMin.emit('close');
      this.isOpen = 0;
  }
  subMenu(sidebar, value, it) {
    if (!sidebar.classList.contains('sidebar-min')) {
      it.classList.toggle('open-sub-menu-style');
      this.isOpen = this.isOpen != 0 ? 0 : value;
    }
  }
}
