import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {HelpMessageComponent} from "./help-message.component";

const routes: Routes = [
  {
    path: '',
    component: HelpMessageComponent,
    data: {
      title: 'Help messages'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HelpMessageRoutingModule { }
