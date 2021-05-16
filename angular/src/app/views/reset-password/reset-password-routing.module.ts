import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ResetPasswordComponent} from './reset-password.component';

const routes: Routes = [
  {
    path: '',
    component: ResetPasswordComponent,
    data: {
      title: 'Reset password'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ResetPasswordRoutingModule { }
