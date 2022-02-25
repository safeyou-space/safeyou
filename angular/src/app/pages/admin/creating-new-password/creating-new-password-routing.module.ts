import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {CreatingNewPasswordComponent} from "./creating-new-password.component";

const routes: Routes = [
  {
    path: '',
    component: CreatingNewPasswordComponent,
    data: {
      title: 'New Password'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CreatingNewPasswordRoutingModule { }
