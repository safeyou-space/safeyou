import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Import Containers
import { DefaultLayoutComponent } from './containers/index';

import { P404Component } from './views/error/404.component';
import { P500Component } from './views/error/500.component';
import { LoginComponent } from './views/login/login.component';
import {CanactivateService} from './shared/Service/canActivate.service';
import {P403Component} from "./views/error/403.component";

export const routes: Routes = [
  {
    path: '',
    loadChildren: './views/safe-you-view/safe-you-view.module#SafeYouViewModule'
  },
  {
    path: '404',
    component: P404Component,
    data: {
      title: 'Page 404'
    }
  },
  {
    path: '403',
    component: P403Component,
    data: {
      title: 'Page 403'
    }
  },
  {
    path: '500',
    component: P500Component,
    data: {
      title: 'Page 500'
    }
  },
  {
    path: 'help/:code/:uri',
    loadChildren: './views/geolocation/geolocation.module#GeolocationModule'
  },
  {
    path: 'administrator/:code/login',
    component: LoginComponent,
    data: {
      title: 'Login Page'
    }
  },
  {
    path: '',
    component: DefaultLayoutComponent,
    canActivateChild: [CanactivateService],
    data: {
      title: 'Home'
    },
    children: [
      {
        path: 'administrator/:code/password/email',
        loadChildren: './views/reset-password/reset-password.module#ResetPasswordModule',
      },
      {
        path: 'administrator/:code/dashboard',
        loadChildren: './views/dashboard/dashboard.module#DashboardModule'
      },
      {
        path: 'administrator/:code/users',
        loadChildren: './views/users/users.module#UsersModule'
      },
      {
        path: 'administrator/:code/administration',
        loadChildren: './views/admin/admin.module#AdminModule'
      },
      {
        path: 'administrator/:code/contents',
        loadChildren: './views/contents/contents.module#ContentsModule'
      },
      {
        path: 'administrator/:code/contact-us',
        loadChildren: './views/contact-us-message/contact-us-message.module#ContactUsMessageModule'
      },
      {
        path: 'administrator/:code/forum',
        loadChildren: './views/forum/forum.module#ForumModule'
      },
      {
        path: 'administrator/:code/forum/:id',
        loadChildren: './views/forum-data/forum-data.module#ForumDataModule'
      },
      {
        path: 'administrator/:code/forum/:id/forum-group/:group_id',
        loadChildren: './views/forum-group/forum-group.module#ForumGroupModule'
      },
      {
        path: 'administrator/:code/languages',
        loadChildren: './views/languages/languages.module#LanguagesModule'
      },
      {
        path: 'administrator/:code/change-country',
        loadChildren: './views/country-list/country-list.module#CountryListModule'
      },
      {
        path: 'administrator/:code/network-category',
        loadChildren: './views/emergency-service-category/emergency-service-category.module#EmergencyServiceCategoryModule'
      },
      {
        path: 'administrator/:code/emergency-service',
        loadChildren: './views/emergency-service/emergency-service.module#EmergencyServiceModule'
      },
      {
        path: 'administrator/:code/help-message',
        loadChildren: './views/help-message/help-message.module#HelpMessageModule'
      },
      {
        path: 'administrator/:code/consultants',
        loadChildren: './views/Profession-Consultant/consultants/consultants.module#ConsultantsModule'
      },
      {
        path: 'administrator/:code/category-consultants',
        loadChildren: './views/Profession-Consultant/category-consultants/category-consultants.module#CategoryConsultantsModule'
      },
      {
        path: 'administrator/:code/sms',
        loadChildren: './views/sms/sms.module#SmsModule'
      },
      {
        path: 'administrator/:code/settings',
        loadChildren: './views/settings/settings.module#SettingsModule'
      },
      {
        path: 'administrator/:code/consultant-requests',
        loadChildren: './views/Profession-Consultant/consultant-requests/consultant-requests.module#ConsultantRequestsModule'
      },
      {
        path: 'administrator/:code/chat-management/groups',
        loadChildren: './views/groups/groups.module#GroupsModule'
      },
      {
        path: 'administrator/:code/contact-us-reply/:id',
        loadChildren: './views/contact-reply/contact-reply.module#ContactReplyModule'
      },
    ]
  },
  { path: '**', component: P404Component }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
