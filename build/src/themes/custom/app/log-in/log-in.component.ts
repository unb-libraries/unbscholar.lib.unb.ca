import { Component } from '@angular/core';
import { LogInComponent as BaseComponent } from '../../../../../app/shared/log-in/log-in.component';

@Component({
  selector: 'ds-log-in',
  // styleUrls: ['./log-in.component.scss'],
  styleUrls: ['../../../../../app/shared/log-in/log-in.component.scss'],
  templateUrl: './log-in.component.html'
  // templateUrl: '../../../../../app/shared/log-in/log-in.component.html'
})
/**
 * Component for a user to enter login credentials.
 */
export class LogInComponent extends BaseComponent {
}
