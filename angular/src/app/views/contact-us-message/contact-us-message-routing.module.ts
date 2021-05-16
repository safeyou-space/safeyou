import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {ContactUsMessageComponent} from "./contact-us-message.component";

const routes: Routes = [
  {
    path: '',
    component: ContactUsMessageComponent,
    data: {
      title: 'Contact us'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ContactUsMessageRoutingModule { }
