import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {ForumComponent} from "./forum.component";

const routes: Routes = [
  {
    path: '',
    component: ForumComponent,
    data: {
      title: 'Forum'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ForumRoutingModule { }
