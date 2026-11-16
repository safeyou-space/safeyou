import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {ContactReplyComponent} from "./contact-reply.component";

const routes: Routes = [
  {
    path: '',
    component: ContactReplyComponent,
    data: {
      title: 'Reply Contact Us'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ContactReplyRoutingModule { }
