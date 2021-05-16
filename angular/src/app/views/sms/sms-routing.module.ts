import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {SmsComponent} from "./sms.component";

const routes: Routes = [
  {
    path: '',
    component: SmsComponent,
    data: {
      title: 'Sms'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SmsRoutingModule { }
