import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PodcastRoutingModule } from './podcast-routing.module';
import {PodcastComponent} from "./podcast.component";
import {SharedModule} from "../../../components/shared.module";
import {ReactiveFormsModule} from "@angular/forms";


@NgModule({
  declarations: [PodcastComponent],
  imports: [
    CommonModule,
    PodcastRoutingModule,
    SharedModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class PodcastModule { }
