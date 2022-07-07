import {NgModule} from '@angular/core';
import {Routes, RouterModule, PreloadAllModules} from '@angular/router';
import {CanActivateService} from "./shared/canActivate.service";
import {NotFoundComponent} from "./pages/admin/not-found/not-found.component";
import {DefaultLayoutComponent} from "./components/default-layout/default-layout.component";
import {CanActivateChildService} from "./shared/canActivateChild.service";

export const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./pages/web/home/home.module').then(m => m.HomeModule)
  },
  {
    path: 'login',
    canActivate: [CanActivateService],
    loadChildren: () => import('./pages/admin/login/login.module').then(m => m.LoginModule),
  },
  {
    path: '404',
    component: NotFoundComponent
  },
  {
    path: 'help/:code/:uri',
    loadChildren: () => import('./pages/web/geolocation/geolocation.module').then(m => m.GeolocationModule)
  },
  {
    path: 'forgot-password',
    loadChildren: () => import('./pages/admin/forgot-password/forgot-password.module').then(m => m.ForgotPasswordModule),
  },
  {
    path: ':country/:language/admin/registration',
    loadChildren: () => import('./pages/admin/user-invite/user-invite.module').then(m => m.UserInviteModule),
    canActivate: [CanActivateService],
  },
  {
    path: ':country/:language/password/:hash',
    loadChildren: () => import('./pages/admin/creating-new-password/creating-new-password.module').then(m => m.CreatingNewPasswordModule),
  },
  {
    path: '',
    component: DefaultLayoutComponent,
    canActivateChild: [CanActivateChildService],
    children: [
      {
        path: ':country/:language/dashboard',
        loadChildren: () => import('./pages/admin/dashboard/dashboard.module').then(m => m.DashboardModule)
      },
      {
        path: ':country/:language/forum',
        loadChildren: () => import('./pages/admin/forum/forum.module').then(m => m.ForumModule),
      },
      {
        path: ':country/:language/podcast',
        loadChildren: () => import('./pages/admin/podcast/podcast.module').then(m => m.PodcastModule)
      },
      {
        path: ':country/:language/communication',
        loadChildren: () => import('./pages/admin/communication/communication.module').then(m => m.CommunicationModule)
      },
      {
        path: ':country/:language/users',
        loadChildren: () => import('./pages/admin/users/app-users/app-users.module').then(m => m.AppUsersModule)
      },
      {
        path: ':country/:language/organizations',
        loadChildren: () => import('./pages/admin/users/organizations/organizations.module').then(m => m.OrganizationsModule)
      },
      {
        path: ':country/:language/consultants',
        loadChildren: () => import('./pages/admin/users/consultants/consultants.module').then(m => m.ConsultantsModule)
      },
      {
        path: ':country/:language/beneficiary',
        loadChildren: () => import('./pages/admin/users/beneficiary/beneficiary.module').then(m => m.BeneficiaryModule)
      },
      {
        path: ':country/:language/reports',
        loadChildren: () => import('./pages/admin/reports/reports.module').then(m => m.ReportsModule)
      },
      {
        path: ':country/:language/sms',
        loadChildren: () => import('./pages/admin/sms/sms.module').then(m => m.SmsModule)
      },
      {
        path: ':country/:language/open_surveys',
        loadChildren: () => import('./pages/admin/open-surveys/open-surveys.module').then(m => m.OpenSurveysModule)
      },
      {
        path: ':country/:language/push-notification',
        loadChildren: () => import('./pages/admin/app-settings/push-notification/push-notification.module').then(m => m.PushNotificationModule)
      },
      {
        path: ':country/:language/about-us',
        loadChildren: () => import('./pages/admin/app-settings/about-us/about-us.module').then(m => m.AboutUsModule)
      },
      {
        path: ':country/:language/police-data',
        loadChildren: () => import('./pages/admin/app-settings/police-data/police-data.module').then(m => m.PoliceDataModule)
      },
      {
        path: ':country/:language/language',
        loadChildren: () => import('./pages/admin/app-settings/language/language.module').then(m => m.LanguageModule)
      },
      {
        path: ':country/:language/settings',
        loadChildren: () => import('./pages/admin/app-settings/settings/settings.module').then(m => m.SettingsModule)
      },
      {
        path: ':country/:language/help-messages',
        loadChildren: () => import('./pages/admin/app-settings/help-messages/help-messages.module').then(m => m.HelpMessagesModule)
      },
      {
        path: ':country/:language/translations',
        loadChildren: () => import('./pages/admin/app-settings/translations/translations.module').then(m => m.TranslationsModule)
      },
      {
        path: ':country/:language/privacy-policy',
        loadChildren: () => import('./pages/admin/app-settings/privacy-policy/privacy-policy.module').then(m => m.PrivacyPolicyModule)
      },
    ]
  },
  {path: '**', component: NotFoundComponent}
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, {
      preloadingStrategy: PreloadAllModules,
      relativeLinkResolution: 'legacy',
      initialNavigation: 'enabled',
    })
  ],
  exports: [
    RouterModule
  ],
  providers: [CanActivateService, CanActivateChildService]
})
export class AppRoutingModule {
}
