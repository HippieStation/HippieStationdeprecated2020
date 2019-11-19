import { Fragment } from 'inferno';
import { act } from '../byond';
import { Box, Button, Section, NoticeBox, LabeledList, ProgressBar } from '../components';

export const Pool = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const poolTemp = {
    5: {
      color: 'bad',
      content: 'Scalding',
    },
    4: {
      color: 'good',
      content: 'Warm',
    },
    3: {
      color: 'good',
      content: 'Normal',
    },
    2: {
      color: 'good',
      content: 'Cool',
    },
    1: {
      color: 'bad',
      content: 'Freezing',
    },
  };
  const temperature = poolTemp[data.temperature] || poolTemp[0];
  return (
    <Fragment>
      <NoticeBox>
        The lock out timer displays: {data.timer}
      </NoticeBox>
      <Section title="Temperature">
        <LabeledList>
          <LabeledList.Item
            label="Current Temperature"
            color={temperature.color}
            content={temperature.content} />
        </LabeledList>
        <Button
          content="Decrease temperature"
          icon="minus"
          onClick={() => act(ref, 'lower_temp')} />
        <Button
          content="Increase temperature"
          icon="plus"
          onClick={() => act(ref, 'raise_temp')} />
      </Section>
      <Section title="Drain">
        <LabeledList>
          <LabeledList.Item
            label="Drain status"
            color={data.drainable ? 'bad' : 'good'}
            content={data.drainable ? "Enabled" : "Disabled"} />
          <LabeledList.Item
            label="Pool status"
            color={data.poolstatus ? 'bad' : 'good'}
            content={data.poolstatus ? "Full" : "Drained"} />
        </LabeledList>
        <Button
          content={data.poolstatus ? "Fill Pool" : "Drain Pool"}
          onClick={() => act(ref, 'toggle_drain')} />
      </Section>
      <Section title="Chemistry">
        <LabeledList>
          <LabeledList.Item
            label="Current Reagent"
            content={data.reagent} />
        </LabeledList>
        <Button
          icon="eject"
          content="Remove Beaker"
          disabled={!data.reagent}
          onClick={() => act(ref, 'remove_beaker')} />
      </Section>
    </Fragment>); };