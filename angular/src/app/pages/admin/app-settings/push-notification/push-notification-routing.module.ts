import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {PushNotificationComponent} from "./push-notification.component";

const routes: Routes = [
  {
    path: '',
    component: PushNotificationComponent,
    data: {
      title: 'Push Notification'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PushNotificationRoutingModule { }
