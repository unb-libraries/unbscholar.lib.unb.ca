import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { TranslateModule } from '@ngx-translate/core';

import { RootModule } from '../../app/root.module';
import { HomePageComponent } from './app/home-page/home-page.component';

const DECLARATIONS = [
  HomePageComponent,
];

@NgModule({
  imports: [
    RootModule,
    CommonModule,
    NgbModule,
    RouterModule,
    TranslateModule,
    ...DECLARATIONS,
  ],
})
/**
 * This module serves as an index for all the components in this theme.
 * It should import all other modules, so the compiler knows where to find any components referenced
 * from a component in this theme
 * It is purposefully not exported, it should never be imported anywhere else, its only purpose is
 * to give lazily loaded components a context in which they can be compiled successfully
 */
class LazyThemeModule {
}
