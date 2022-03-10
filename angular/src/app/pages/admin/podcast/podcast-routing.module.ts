import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {PodcastComponent} from "./podcast.component";

const routes: Routes = [
  {
    path: '',
    component: PodcastComponent,
    data: {
      title: 'Podcast'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PodcastRoutingModule { }
