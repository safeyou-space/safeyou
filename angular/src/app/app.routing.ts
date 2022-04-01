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
