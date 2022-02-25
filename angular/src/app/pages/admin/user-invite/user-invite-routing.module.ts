import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {UserInviteComponent} from "./user-invite.component";

const routes: Routes = [
  {
    path: '',
    component: UserInviteComponent,
    data: {
      title: 'User Invite'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class UserInviteRoutingModule { }
