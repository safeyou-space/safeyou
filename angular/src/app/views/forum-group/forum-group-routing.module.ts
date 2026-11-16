import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {ForumGroupComponent} from "./forum-group.component";

const routes: Routes = [
  {
    path: '',
    component: ForumGroupComponent,
    data: {
      title: 'Forum comment'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ForumGroupRoutingModule { }
