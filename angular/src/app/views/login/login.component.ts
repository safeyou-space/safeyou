import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import { RequestService } from '../../shared/Service/request.service';
import {environment} from '../../../environments/environment.prod';

@Component({
  selector: 'app-dashboard',
  templateUrl: 'login.component.html',
  styleUrls: ['login.component.css']
})
export class LoginComponent implements OnInit {

  public error;
  myStyle: object = {};
  myParams: object = {};
  width = 100;
  height = 100;
  loading = false;
  token = localStorage.getItem('access_token');

  constructor(public router: Router,
              public activeRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
    this.navigateDashboard();
  }

  ngOnInit() {
    // login page styles
    this.myStyle = {
      'background': 'radial-gradient(ellipse at center, rgba(255, 255, 255, 1) 0%, rgba(19, 80, 88, 1) 100%)',
      'position': 'fixed',
      'width': '100%',
      'height': '100%',
      'z-index': -1,
      'top': 0,
      'left': 0,
      'right': 0,
      'bottom': 0,
    };
    // login page styles
    this.myParams = {
      particles: {
        number: {
          value: 60,
          'density': {
            'enable': true,
            'value_area': 1000
          }
        },
        color: {
          'value': ['#344455', '#ffffff']
        },
        shape: {
          'type': 'edge',
          'stroke': {
            'width': 0,
            'color': '#000000'
          },
          'polygon': {
            'nb_sides': 5
          },
          'image': {
            'src': 'img/github.svg',
            'width': 100,
            'height': 100
          }
        },
        'opacity': {
          'value': 0.5,
          'random': false,
          'anim': {
            'enable': false,
            'speed': 1,
            'opacity_min': 0.1,
            'sync': false
          }
        },
        'size': {
          'value': 4,
          'random': true,
          'anim': {
            'enable': false,
            'speed': 40,
            'size_min': 0.1,
            'sync': false
          }
        },
        'line_linked': {
          'enable': true,
          'distance': 50,
          'color': '#fff',
          'opacity': 0.5,
          'width': 1
        },
        'move': {
          'enable': true,
          'speed': 3,
          'direction': 'none',
          'random': false,
          'straight': false,
          'out_mode': 'out',
          'bounce': false,
          'attract': {
            'enable': false,
            'rotateX': 600,
            'rotateY': 1200
          }
        }
      }
    };
  }

  // send login request
  onLogin(form) {
    this.loading = true;
    this.requestService.createData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.login}`, form).subscribe((res) => {
      localStorage.setItem('access_token', res['access_token']);
      localStorage.setItem('image', res['image']);
      localStorage.setItem('refresh_token', res['refresh_token']);
      localStorage.setItem('first_name', res['first_name']);
      localStorage.setItem('is_super_admin', res['is_super_admin']);
      localStorage.setItem('id', res['user_id']);
      localStorage.setItem('is_admin', res['is_admin']);
      localStorage.setItem('last_name', res['last_name']);
      this.requestService.userInfo['first_name'] = res['first_name'];
      this.requestService.userInfo['last_name'] = res['last_name'];
      this.requestService.userInfo['role'] = res['role'];
      this.requestService.userInfo['image'] = res['image'];
      this.requestService.userInfo['isSuperAdmin'] = res['is_super_admin'];
      this.requestService.userInfo['isAdmin'] = res['is_admin'];
      if (res['access']) {
        localStorage.setItem('access', JSON.stringify(res['access']));
      }
      this.navigateDashboard();
      this.loading = false;
    }, (error) => {
      this.loading = false;
      this.error = error.error.message && error.error.message['password'] ? error.error.message['password'] : error.error.message;
    });
  }

  // check is have a access token or not
  navigateDashboard() {
    if (localStorage.getItem('access_token') && localStorage.getItem('is_super_admin') == 'true') {
      this.router.navigate([`administrator/${this.requestService.activeCountryCode}/change-country`]);
    } else if (localStorage.getItem('access_token') && localStorage.getItem('is_super_admin') != 'true') {
      this.router.navigate([`administrator/${this.requestService.activeCountryCode}/dashboard`]);
    }
  }
}
