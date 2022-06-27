import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {HelpMessagesComponent} from "./help-messages.component";

const routes: Routes = [
  {
    path: '',
    component: HelpMessagesComponent,
    data: {
      title: 'Help Messages'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HelpMessagesRoutingModule { }
