import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {AppUsersComponent} from "./app-users.component";

const routes: Routes = [
  {
    path: '',
    component: AppUsersComponent,
    data: {
      title: 'Users'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AppUsersRoutingModule { }
