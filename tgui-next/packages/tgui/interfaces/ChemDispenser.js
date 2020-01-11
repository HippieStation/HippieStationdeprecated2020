import { toFixed } from 'common/math';
import { toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Icon, LabeledList, ProgressBar, Section } from '../components';

export const ChemDispenser = props => {
  const { act, data } = useBackend(props);
  // TODO: Change how this piece of shit is built on server side
  // It has to be a list, not a fucking OBJECT!
  const recipes = Object.keys(data.recipes)
    .map(a => ({
      name: data.recipes[a].recipe_name,
      contents: data.recipes[a].contents,
    }));
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents = data.beakerContents || [];
  return (
    <Fragment>
      <Section
        title="Status">
        <LabeledList>
          <LabeledList.Item label="Energy">
            <ProgressBar
              value={data.energy / data.maxEnergy}
              content={toFixed(data.energy) + ' units'} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Recipes"
        buttons={(
          <Fragment>
            <Box inline mx={1}>
              <Button
                color="transparent"
                content="Clear Recipes"
                onClick={() => act('clear_recipes')} />
            </Box>
            <Button
              icon="circle"
              content="Add Recipe"
              onClick={() => act('add_recipe')} />
          </Fragment>
        )}>
        {recipes.map(recipe => (
          <Button key={recipe.name}
            icon="tint"
            width="129.5px"
            lineHeight="21px"
            content={recipe.name}
            onClick={() => act('dispense_recipe', {
              recipe: recipe.contents,
            })} />
        ))}
        {recipes.length === 0 && (
          <Box color="light-gray">
            No recipes.
          </Box>
        )}
      </Section>
      <Section
        title="Dispense"
        buttons={(
          beakerTransferAmounts.map(amount => (
            <Button key={amount}
              icon="plus"
              selected={amount === data.amount}
              content={amount}
              onClick={() => act('amount', {
                target: amount,
              })} />
          ))
        )}>
        <Box mr={-1}>
          {data.chemicals.map(chemical => (
            <Button key={chemical.id}
              icon="tint"
              width="129.5px"
              lineHeight="21px"
              content={chemical.title}
              onClick={() => act('dispense', {
                reagent: chemical.id,
              })} />
          ))}
        </Box>
      </Section>
      <Section
        title="Beaker"
        buttons={(
          beakerTransferAmounts.map(amount => (
            <Button key={amount}
              icon="minus"
              content={amount}
              onClick={() => act('remove', { amount })} />
          ))
        )}>
        <LabeledList>
          <LabeledList.Item
            label="Beaker"
            buttons={!!data.isBeakerLoaded && (
              <Button
                icon="eject"
                content="Eject"
                disabled={!data.isBeakerLoaded}
                onClick={() => act('eject')} />
            )}>
            {data.isBeakerLoaded
              && (
                <Fragment>
                  <AnimatedNumber
                    initial={0}
                    value={data.beakerCurrentVolume} />
                  /{data.beakerMaxVolume} units
                </Fragment>
              )
              || 'No beaker'}
          </LabeledList.Item>
          <LabeledList.Item
            label="Contents">
            <Box color="label">
              {(!data.isBeakerLoaded) && 'N/A'
                || beakerContents.length === 0 && 'Nothing'}
            </Box>
            {beakerContents.map(chemical => (
              <Box
                key={chemical.name}
                color="label">
                <AnimatedNumber
                  initial={0}
                  value={chemical.volume} />
                {' '}
                units of {chemical.name}
              </Box>
            ))}
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Fragment>
  );
};
