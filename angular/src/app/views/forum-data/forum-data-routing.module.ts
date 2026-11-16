import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {ForumDataComponent} from "./forum-data.component";

const routes: Routes = [
  {
    path: '',
    component: ForumDataComponent,
    data: {
      title: 'Forum Data'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ForumDataRoutingModule { }
